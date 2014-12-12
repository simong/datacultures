class Canvas::GenericUrlProcessor

  attr_accessor  :generic_url_conf, :request_object

   def call(submission)

    user_id        = submission['user_id']
    assignment_id  = submission['assignment_id']
    submitted_at   = submission['submitted_at']
    url            = submission['url']
    image_url      = submission.try(:[], 'attachments').try(:first).try(:[],'url')

    previous_item = GenericUrl.where({assignment_id: assignment_id, canvas_user_id: user_id}).first

    if previous_item.nil?   # new submission, or previous submission was a different type

      MediaUrl.where({canvas_assignment_id: assignment_id, canvas_user_id: user_id}).delete_all
      Attachment.where({assignment_id: assignment_id, canvas_user_id: user_id}).delete_all
      generic_url = GenericUrl.create(
        { assignment_id: assignment_id,
          canvas_user_id: user_id,
          url: url,
          image_url: image_url,
          submitted_at: submitted_at
        })

    elsif previous_item.submitted_at.to_time != Time.parse(submitted_at)

       generic_url = GenericUrl.where( { assignment_id: assignment_id, canvas_user_id: user_id} ).first
       generic_url.update_attributes(
         { url: url,
           image_url: image_url,
           submitted_at: submitted_at
         })
    end

  end

end
