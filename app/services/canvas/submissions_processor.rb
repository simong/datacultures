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
      assignment_id = submission['assignment_id']
      user_id       = submission['user_id']

      # Handle the submission
      log_submission( attachment_processor, generic_url_processor, media_url_processor,
                      student_ids, submission, assignment_id, user_id)

      # Record a `submission` activity
      if user_id   && !(scored_submissions.include?([assignment_id.to_s, user_id]))
        Activity.score!({scoring_item_id: assignment_id,
                         canvas_user_id: user_id, reason: 'Submission',
                         score: submission_conf.active, delta: submission_conf.points_associated,
                         canvas_updated_at: submission['submitted_at'] })
      end
    end

  end

  def log_submission(attachment_processor, generic_url_processor, media_url_processor,
                      student_ids, submission, assignment_id, user_id)
    url = submission['url']
    submitted_at = submission['submitted_at']
    has_url = (url && !url.empty?)
    attachments = submission['attachments']

    # Create a student record if we haven't seen this student yet
    if !student_ids.include?(user_id.to_i)
      Student.create_by_canvas_user_id(user_id)
    end

    # If the submission was a URL to a known video system such as youtube or vimeo
    # we let the media url processor deal with it
    if has_url && url =~ video_url_regexp
      media_url_processor.call(submission)

    # If it was a regular URL we let the generic url processor deal with it
    elsif has_url
      generic_url_processor.call(submission)

    # If regular file attachments were uploaded, the attachment processor can handle it
    elsif attachments && !attachments.empty?
      attachment_processor.call(submission, attachments)
    end
  end

  def video_url_regexp
    /\Ahttps?:\/\/www\.youtube\.com|\Ahttps?:\/\/youtu\.be|www\.youtube.com\/embed|\Ahttps?:\/\/vimeo\.com|player\.vimeo\.com\/video/
  end

end
