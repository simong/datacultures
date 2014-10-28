class AssignmentUpdateWorker

  include Sidekiq::Worker
  include CanvasRelativeUrlHelper

  def perform( base_url, course )
    request_object = ApiRequest.new(base_url: base_url, api_key: AppConfig::CourseConstants.api_key)
    processor = Canvas::AssignmentsProcessor.new({request_object: request_object, course: course })
    Canvas::PagedApiProcessor.new({request_object: request_object,
                                   handler: processor}).call(course_api_url(course: course, final_url: :assignments))
    Activity.update_scores!
  end

end

