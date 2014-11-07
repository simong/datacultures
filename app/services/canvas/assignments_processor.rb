class Canvas::AssignmentsProcessor

  include CanvasRelativeUrlHelper

  attr_accessor :request_object, :submissions_processor, :course, :paged_api_processor

  def initialize(conf)
    @course = conf[:course] || AppConfig::CourseConstants.course
    @request_object = conf[:request_object] || ApiRequest.new(api_key: conf[:api_key], base_url: conf[:base_url])
    @submissions_processor = conf[:submissions_processor] || Canvas::SubmissionsProcessor.new({request_object: request_object, course: course})
    @paged_api_processor = conf[:paged_api_processor] || Canvas::PagedApiProcessor.new({ handler: submissions_processor})
  end

  def call(assignments)

    Assignment.sync_if_needed(assignments_data: assignments)

    assignments.each do |assignment|
      processing_url = course_api_url(course: course, final_url: :submissions,
                                      mid_variable: assignment['id'].to_s, mid_const: :assignments)
      if assignment['has_submitted_submissions']
        paged_api_processor.call(processing_url)
      end
    end

  end

end
