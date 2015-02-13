class Canvas::AttachmentsProcessor

  def initialize(request_object, course)
    @thumbnail_generator = ThumbnailGenerator.new(request_object, course)
  end

  def call(submission, attachments)
    assignment_id = submission['assignment_id']
    user_id       = submission['user_id']

    # Delete any previous attachments or urls
    Attachment.where({submission_id: submission['id'], canvas_user_id: user_id}).delete_all
    MediaUrl.where({canvas_assignment_id: assignment_id, canvas_user_id: user_id}).delete_all
    GenericUrl.where({assignment_id: assignment_id, canvas_user_id: user_id}).delete_all

    # Create a new record and generate a thumbnail for each attachment
    attachments.each do |attachment|
      handle_attachment(submission, attachment)
    end
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
      content_type: attachment['content-type'],
      canvas_user_id: submission['user_id'],
      assignment_id: submission['assignment_id'],
      submission_id: submission['id'],
      date: Time.parse(attachment['updated_at']),
      attachment_id: attachment['id'],
      image_url: attachment['url'],
      thumbnail_url: thumbnail_url
    })
  end

end
