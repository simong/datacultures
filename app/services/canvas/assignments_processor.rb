class Canvas::AssignmentsProcessor

  attr_accessor :request_object, :submissions_processor, :course, :paged_api_processor

  def initialize(conf)
    @course = conf[:course] || AppConfig::CourseConstants.course
    @request_object = conf[:request_object] || ApiRequest.new(api_key: conf[:api_key], base_url: conf[:base_url])
    @submissions_processor = conf[:submissions_processor] || Canvas::SubmissionsProcessor.new({request_object: request_object, course: course})
    @paged_api_processor = conf[:paged_api_processor] || Canvas::PagedApiProcessor.new({ handler: submissions_processor})
  end

  def call(assignments)

    assignments.each do |assignment|
      if assignment['has_submitted_submissions']
        paged_api_processor.call('api/v1/courses/'+course.to_s+'/assignments/'+assignment['id'].to_s+'/submissions?per_page=250')
      end
    end

  end

end
