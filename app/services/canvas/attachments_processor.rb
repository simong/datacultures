class Canvas::AttachmentsProcessor

  def initialize(request_object, course)
    @thumbnail_generator = ThumbnailGenerator.new(request_object, course)
  end

  def call(submission, attachments)
    previously_credited = Activity.where({
      scoring_item_id: submission['assignment_id'].to_s,
      reason: 'Submission',
      canvas_user_id: submission['user_id']
    }).first

    ## Attachments on a submission are processed in two cases:
    #    1.  It has not been done before for this student and this assignment, or
    #    2.  The assignment has been resubmitted (the date is after the already credited date)
    if needs_processing?(previously_credited, submission['submitted_at'])
      # Delete any attachments that are already associated with the submission (if any)
      Attachment.where({
        canvas_user_id: submission['user_id'],
        submission_id: submission['id']
      }).delete_all

      # Create a new record and generate a thumbnail for each attachment
      attachments.each do |attachment|
        handle_attachment(submission, attachment)
      end

      # Update the submittal date
      if previously_credited
        previously_credited.update_attribute(:canvas_updated_at, submission['submitted_at'])
      end
    end
  end

  def needs_processing?(previously_credited, new_date)
    previously_credited.nil? || (previously_credited.canvas_updated_at.to_time != Time.parse(new_date))
  end

  def handle_attachment(submission, attachment)
    assignment_id = submission['assignment_id']
    url           = attachment['url']
    content_type  = attachment['content-type']
    thumbnail_url = nil

    # Generate a thumbnail if possible
    if url && @thumbnail_generator.can_process(content_type)
      thumbnail_url = @thumbnail_generator.generate_and_upload(assignment_id, url, content_type)
    end

    # Persist an attachment record
    Attachment.create({
      content_type: submission['content-type'],
      canvas_user_id: submission['user_id'],
      assignment_id: submission['assignment_id'],
      submission_id: submission['id'],
      date: Time.parse(attachment['updated_at']),
      attachment_id: attachment['id'],
      image_url: attachment['url'],
      thumbnail_url: thumbnail_url,
      content_type: attachment['content-type']
    })
  end

end
