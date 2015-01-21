class Canvas::MediaUrlProcessor

  require 'string_refinement'
  using StringRefinement

  def initialize(request_object, course)
    @thumbnail_generator = ThumbnailGenerator.new(request_object, course)
  end

  def call(submission)
    user_id        = submission['user_id']
    assignment_id  = submission['assignment_id']
    submitted_at   = submission['submitted_at']
    url            = submission['url']

    previous_item = MediaUrl.where({canvas_assignment_id: assignment_id, canvas_user_id: user_id}).first

    # If this is a new submission, or the previous submission was of a different type, the previous_item
    # will be nil. We can delete all other types (files and media urls) and create a new media url
    if previous_item.nil?
      # Generate a thumbnail for the URL
      thumbnail_url = nil
      if url
        site_and_slug = url.extract_site_and_slug
        thumbnail_url = Video::Metadata.thumbnail_url(site_and_slug[:site_tag], site_and_slug[:site_id])
      end

      # Delete gemeric urls and file uploads (attachments)
      GenericUrl.where({assignment_id: assignment_id, canvas_user_id: user_id}).delete_all
      Attachment.where({assignment_id: assignment_id, canvas_user_id: user_id}).delete_all

      # Create a new media url
      generic_url = MediaUrl.create({
        canvas_assignment_id: assignment_id,
        url: url,
        canvas_user_id: user_id,
        thumbnail_url: thumbnail_url,
        submitted_at: submitted_at
      })

    # If the user updated his submission
    elsif previous_item.submitted_at.to_time != Time.parse(submitted_at) || previous_item.url != url
      # Generate a thumbnail for the URL
      thumbnail_url = nil
      if url
        site_and_slug = url.extract_site_and_slug
        thumbnail_url = Video::Metadata.thumbnail_url(site_and_slug[:site_tag], site_and_slug[:site_id])
      end

      # Update the metadata in the database
      previous_item.update_attributes({
        url: url,
        thumbnail_url: thumbnail_url,
        submitted_at: submitted_at
      })
    end

  end

end
