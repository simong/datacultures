class Canvas::SubmissionsProcessor

  attr_accessor  :submission_conf, :request_object

  def initialize(conf)
    @submission_conf = PointsConfiguration.where({interaction: 'Submission'}).first
    @request_object     = conf[:request_object] || Canvas::ApiRequest.new({api_key: conf['api_key'], base_url: conf['base_url']})
  end

  def call(submissions)

    ## rewrite for return data from assignments API call
    scoring_submissions = Activity.where({reason: 'Submission'}).select(:canvas_scoring_item_id, :canvas_user_id)
    if scoring_submissions
      scored_submissions = scoring_submissions.map{|s| [s.canvas_scoring_item_id, s.canvas_user_id] }
    else
      scored_submissions = []
    end

    student_names =  Student.get_students_by_canvas_id
    canvas_student_ids = student_names.keys

    # TODO: move back further - maybe as early as PagedApiProcessor; and create if needed here
    attachment_processor = Canvas::AttachmentsProcessor.new({})

    submissions.each do |submission|
      user_id    = submission['user_id']
      assignment_id = submission['assignment_id']
      attachment_data = []

      has_url = (submission['url'] && !submission['url'].empty?)
      # Student::create_by_canvas_user_id is safe, but why do the extra SQL query every time?
      if !canvas_student_ids.include?(user_id.to_i)
        Student.create_by_canvas_user_id(user_id)
      end
      if (has_url || submission['attachments'])
        previously_credited = Activity.where({canvas_scoring_item_id: submission['assignment_id'],
                                              reason: 'Submission', canvas_user_id: submission['user_id']}).first
        if has_url
            MediaUrl.process_submission_url(url: submission['url'], canvas_user_id: user_id,
                                            assignment_id: assignment_id, author: student_map[user_id])
        end
        if  submission['attachments']
          process_attachments_to_submission(attachment_processor, student_map, submission, previously_credited)
        end
      end

      if user_id   && !(scored_submissions.include?([assignment_id, user_id]))
        Activity.score!({canvas_scoring_item_id: assignment_id,
                         canvas_user_id: user_id, reason: 'Submission',
                         body: attachment_data.to_json,
                         score: submission_conf.active, delta: submission_conf.points_associated,
                         canvas_updated_at: submission['submitted_at'] })
      end
    end

  end

  def process_attachments_to_submission(attachment_processor, student_map, submission, previously_credited)
    ## Attachments on a submission are processed in two cases:
    #     1. It has not been done before for this student and this assignment, or
    #     2. The assignment has been resubmitted (the date is after the already credited date)
    if needs_processing?(previously_credited, submission['submitted_at'])
      attachment_processor.attachment_conf = {content_type: submission['content-type'], canvas_user_id: submission['user_id'],
                                              assignment_id: submission['assignment_id'], submission_id: submission['id'], author: student_map[submission['user_id']]}
      attachment_processor.call(submission['attachments'])
      previously_credited.update_attribute(:canvas_updated_at, submission['submitted_at']) if previously_credited
    end
  end

  def needs_processing?(previously_credited, new_date)
    previously_credited.nil? || (previously_credited.canvas_updated_at.to_time != Time.parse(new_date))
  end

end
