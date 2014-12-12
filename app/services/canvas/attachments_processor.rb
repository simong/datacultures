class Canvas::AttachmentsProcessor

  attr_accessor :attachment_conf #, :request_object

  # called once per submission
  def call(attachments)
    Attachment.where({canvas_user_id: attachment_conf[:canvas_user_id], submission_id: attachment_conf[:submission_id]}).
       delete_all
    attachments.each do |attachment|
      Attachment.create(attachment_conf.merge({date: Time.parse(attachment['updated_at']),
                        attachment_id: attachment['id'], image_url: attachment['url'], content_type: attachment['content-type']})
      )
     end
  end

end
