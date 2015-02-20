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
    site_and_slug  = nil

    # If this is a new submission, or the previous submission was of a different type, the previous_item
    # will be nil. We can delete all other types (files and media urls) and create a new media url
    previous_item = MediaUrl.where({canvas_assignment_id: assignment_id, canvas_user_id: user_id}).first
    if previous_item.nil?
      # Delete generic urls and file uploads (attachments)
      GenericUrl.where({assignment_id: assignment_id, canvas_user_id: user_id}).delete_all
      Attachment.where({assignment_id: assignment_id, canvas_user_id: user_id}).delete_all

      # Create a new media url object
      create_media_url(assignment_id, url, user_id, submitted_at)

    # Otherwise this is an existing submissions pointing to a media URL that we've updated
    # with a new media url
    else
      # We delete the existing item as things like likes are probably no longer be relevant
      previous_item.delete

      # Create a new media url object
      create_media_url(assignment_id, url, user_id, submitted_at)
    end
  end

  # Create a new media URL record in the database
  def create_media_url(assignment_id, url, user_id, submitted_at)
    # Generate a thumbnail for the URL
    thumbnail_url = nil
    site_and_slug = nil
    if url
      site_and_slug = url.extract_site_and_slug
      thumbnail_url = Video::Metadata.thumbnail_url(site_and_slug[:site_tag], site_and_slug[:site_id])
    end

    options = {
      canvas_assignment_id: assignment_id,
      url: url,
      canvas_user_id: user_id,
      thumbnail_url: thumbnail_url,
      submitted_at: submitted_at
    }
    if !site_and_slug.nil?
      options = options.merge({
        site_tag: site_and_slug[:site_tag],
        site_id: site_and_slug[:site_id]
      })
    end
    MediaUrl.create(options)
  end
end
