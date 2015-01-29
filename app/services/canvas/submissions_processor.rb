class Canvas::SubmissionsProcessor

  attr_accessor  :submission_conf, :request_object

  require 'array_refinement'
  using ArrayRefinement

  def initialize(conf)
    @submission_conf = PointsConfiguration.where({interaction: 'Submission'}).first
    @request_object     = conf[:request_object] || ApiRequest.new(api_key: conf['api_key'], base_url: conf['base_url'])
    @course = conf[:course]
  end

  def call(submissions)

    ## rewrite for return data from assignments API call
    scoring_submissions = Activity.where({reason: 'Submission'}).select(:scoring_item_id, :canvas_user_id)
    if scoring_submissions
      scored_submissions = scoring_submissions.map{|s| [s.scoring_item_id, s.canvas_user_id] }
    else
      scored_submissions = []
    end

    student_ids = Student.all.map(&:canvas_user_id)
    attachment_processor = Canvas::AttachmentsProcessor.new(@request_object, @course)
    generic_url_processor = Canvas::GenericUrlProcessor.new(@request_object, @course)
    media_url_processor = Canvas::MediaUrlProcessor.new(@request_object, @course)

    submissions.each do |submission|
      # Handle the submission
      log_submission( attachment_processor, generic_url_processor, media_url_processor,
                      student_ids, submission)
    end

  end

  def log_submission(attachment_processor, generic_url_processor, media_url_processor,
                      student_ids, submission)

    assignment_id = submission['assignment_id']
    user_id       = submission['user_id']
    url           = submission['url']
    submitted_at  = submission['submitted_at']
    has_url       = (url && !url.empty?)
    is_media_url  = (has_url && url =~ video_url_regexp)
    attachments   = submission['attachments']

    # Create a student record if we haven't seen this student yet
    if !student_ids.include?(user_id.to_i)
      Student.create_by_canvas_user_id(user_id)
    end

    # If this is a resubmission, we already have an activity we'll need to update
    previously_credited = Activity.where({
      scoring_item_id: assignment_id.to_s,
      reason: 'Submission',
      canvas_user_id: user_id
    }).first

    # Check whether we really need to process this submission
    if needs_processing?(previously_credited, submitted_at, assignment_id, user_id, has_url, is_media_url)

      # If the submission was a URL to a known video system such as youtube or vimeo
      # we let the media url processor deal with it
      if is_media_url
        media_url_processor.call(submission)

      # If it was a regular URL we let the generic url processor deal with it
      elsif has_url
        generic_url_processor.call(submission)

      # If regular file attachments were uploaded, the attachment processor can handle it
      elsif attachments && !attachments.empty?
        attachment_processor.call(submission, attachments)
      end

      # If this is a resubmission, we update the timestamp on the activity record
      if previously_credited
        previously_credited.update_attribute(:canvas_updated_at, submission['submitted_at'])

      # Otherwise we create a new submission activity record
      else
        Activity.score!({
          scoring_item_id: assignment_id,
          canvas_user_id: user_id, reason: 'Submission',
          score: submission_conf.active, delta: submission_conf.points_associated,
          canvas_updated_at: submission['submitted_at']
        })
      end
    end
  end

  # A regular expression that checks if a URL is pointing to a known media system such as YouTube or Vimeo
  def video_url_regexp
    /\Ahttps?:\/\/www\.youtube\.com|\Ahttps?:\/\/youtu\.be|www\.youtube.com\/embed|\Ahttps?:\/\/vimeo\.com|player\.vimeo\.com\/video/
  end

  # Check whether a submission needs processing
  def needs_processing?(previously_credited, new_date, assignment_id, user_id, has_url, is_media_url)
    # If:
    #  - this is a new submission
    #  - this is a resubmission
    # we need to process it
    if previously_credited.nil? || previously_credited.canvas_updated_at.nil? || (previously_credited.canvas_updated_at.to_time != Time.parse(new_date))
      return true
    end

    # If this is a generic URL submitted in the last 2 minutes for which we don't have a thumbnail yet,
    # we process it. This is because Canvas generates images for generic URLs asynchronously and we have to
    # give it a little bit of time
    if has_url && !is_media_url
      generic_url = GenericUrl.where({assignment_id: assignment_id, canvas_user_id: user_id}).first
      if generic_url.nil? || generic_url.thumbnail_url.nil?
        return true
      end
    end
  end

end
