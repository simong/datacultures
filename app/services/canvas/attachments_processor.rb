class Canvas::AttachmentsProcessor

  attr_accessor :attachment_conf #, :request_object

  def initialize(conf)
    @attachment_conf = conf.select{|k,v| [:canvas_user_id, :assignment_id, :submission_id, :author].include? k }     # expects canvas_user_id, assignment_id and submission_id
  end

  # called once per submission
  def call(attachments)
    Attachment.where({canvas_user_id: attachment_conf[:canvas_user_id], submission_id: attachment_conf[:submission_id]}).
       delete_all
    attachments.each do |attachment|
      Attachment.create(attachment_conf.merge({date: Time.parse(attachment['updated_at']).to_s(:gallery),
                        attachment_id: attachment['id'], url: attachment['url'], content_type: attachment['content-type']})
      )
     end
  end

end
