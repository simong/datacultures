class Canvas::GenericUrlProcessor

  def initialize(request_object, course)
    @thumbnail_generator = ThumbnailGenerator.new(request_object, course)
  end

  def call(submission)
    user_id        = submission['user_id']
    assignment_id  = submission['assignment_id']
    submitted_at   = submission['submitted_at']
    url            = submission['url']
    image_url      = submission.try(:[], 'attachments').try(:first).try(:[],'url')

    previous_item = GenericUrl.where({assignment_id: assignment_id, canvas_user_id: user_id}).first

    # If this is a new submission, or the previous submission was of a different type, the previous_item
    # will be nil. We can delete all other types (files and media urls) and create a new generic url
    if previous_item.nil?
      # Generate a thumbnail for the URL. Because the image URL is generated by canvas asynchronously, the
      # image_url might not immediately be available. Obviously we can only generate a thumbnail once the
      # image_url is present
      thumbnail_url = nil
      if image_url
        thumbnail_url = @thumbnail_generator.generate_and_upload(assignment_id, image_url)
      end

      # Delete media urls and file uploads (attachments)
      MediaUrl.where({canvas_assignment_id: assignment_id, canvas_user_id: user_id}).delete_all
      Attachment.where({assignment_id: assignment_id, canvas_user_id: user_id}).delete_all

      # Create a new generic url
      generic_url = GenericUrl.create({
        assignment_id: assignment_id,
        canvas_user_id: user_id,
        url: url,
        image_url: image_url,
        thumbnail_url: thumbnail_url,
        submitted_at: submitted_at
      })

    # If the user updated his submission
    elsif previous_item.submitted_at.to_time != Time.parse(submitted_at) || previous_item.image_url != image_url
      # Generate a thumbnail for the URL. Because the image URL is generated by canvas asynchronously, the
      # image_url might not immediately be available. Obviously we can only generate a thumbnail once the
      # image_url is present. Additionally, if the U
      thumbnail_url = nil
      if image_url
        thumbnail_url = @thumbnail_generator.generate_and_upload(assignment_id, image_url)
      end

      # Update the metadata in the database
      previous_item.update_attributes({
        url: url,
        image_url: image_url,
        thumbnail_url: thumbnail_url,
        submitted_at: submitted_at
      })
    end

  end

end
