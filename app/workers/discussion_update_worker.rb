class DiscussionUpdateWorker

  include Sidekiq::Worker
  include CanvasRelativeUrlHelper

  def perform( base_url, course )
    request_object = ApiRequest.new(base_url: base_url, api_key: AppConfig::CourseConstants.api_key)
    discussion_topics_processor = Canvas::DiscussionTopicsProcessor.new({request_object: request_object, course: course })
    Canvas::PagedApiProcessor.new({request_object: request_object,
                                   handler: discussion_topics_processor}).call(course_api_url(course: course, final_url: :discussion_topics))
  end

end

