task :migrate_old_submissions => :environment do

  include CanvasRelativeUrlHelper

  # Basic setup:
  course = AppConfig::CourseConstants.course
  api_key = AppConfig::CourseConstants.api_key
  base_url = AppConfig::CourseConstants.base_url
  request_object = ApiRequest.new(api_key: api_key, base_url: base_url)
  submissions_processor = SubmissionsProcessor.new(request_object, course)
  paged_api_processor = Canvas::PagedApiProcessor.new({ handler: submissions_processor})

  # 1. Get all assignments from the database
  assignments = Assignment.all

  # 2. Process the submissions for each assignment from Canvas
  assignments.each do |assignment|
    processing_url = course_api_url(course: course, final_url: :submissions, mid_variable: assignment['canvas_assignment_id'].to_s, mid_const: :assignments)
    paged_api_processor.call(processing_url)
  end
end

class SubmissionsProcessor

  require 'string_refinement'
  using StringRefinement

  attr_accessor :request_object

  def initialize(request_object, course)
    @request_object = request_object
    @course = course
    @thumbnail_generator = ThumbnailGenerator.new(request_object, course)
  end

  def call(submissions)
    submissions.each do |submission|
      assignment_id  = submission['assignment_id']
      user_id        = submission['user_id']
      url            = submission['url']
      submitted_at   = submission['submitted_at']
      attachments    = submission['attachments']
      has_url        = (url && !url.empty?)
      is_media_url   = (has_url && url =~ video_url_regexp)
      is_generic_url = (has_url && !is_media_url)
      is_file_upload = (!has_url)


      # Media URLs
      if (is_media_url)
        # Extract the title and thumbnail
        site_and_slug = url.extract_site_and_slug
        thumbnail_url = Video::Metadata.thumbnail_url(site_and_slug[:site_tag], site_and_slug[:site_id])

        # Update the record
        MediaUrl.where({
          canvas_assignment_id: assignment_id,
          canvas_user_id: user_id
        }).first.update_attributes({thumbnail_url: thumbnail_url})

      # Generic URLs:
      elsif is_generic_url
        # If Canvas was able to generate an image for the generic URL,
        # we generate a thumbnail and update the record
        image_url       = submission.try(:[], 'attachments').try(:first).try(:[],'url')
        if image_url
          thumbnail_url = @thumbnail_generator.generate_and_upload(assignment_id, image_url, 'image/jpeg', {quality: 100, gravity: 'north'})
          GenericUrl.where({
            assignment_id: assignment_id,
            canvas_user_id: user_id
          }).first.update_attributes({thumbnail_url: thumbnail_url})
        end

      # File uploads:
      elsif is_file_upload
        attachments.each do |attachment|
          url           = attachment['url']
          content_type  = attachment['content-type']

          # Check if we can generate a thumbnail for this attachment
          if url && @thumbnail_generator.can_process(content_type)
            # Generate the thumbnail and update the record
            thumbnail_url = @thumbnail_generator.generate_and_upload(assignment_id, url, content_type)
            att = Attachment.where({
              assignment_id: assignment_id,
              canvas_user_id: user_id
            }).first
            att.update_attributes({thumbnail_url: thumbnail_url})
          end
        end
      end
    end
  end

  # A regular expression that checks if a URL is pointing to a known media system such as YouTube or Vimeo
  def video_url_regexp
    /\Ahttps?:\/\/www\.youtube\.com|\Ahttps?:\/\/youtu\.be|www\.youtube.com\/embed|\Ahttps?:\/\/vimeo\.com|player\.vimeo\.com\/video/
  end
end
