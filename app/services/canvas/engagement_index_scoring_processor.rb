class Canvas::EngagementIndexScoringProcessor

  attr_accessor  :discussion_topics_processor, :assignments_processor, :request_object, :course

  def initialize(config)
    @course                      = config[:course] || AppConfig::CourseConstants.course
    @request_object              = config[:request_object] ||= ApiRequest.new(base_url: config[:base_url], api_key: config[:api_key])
    @discussion_topics_processor = config[:discussions_processor] ||= Canvas::DiscussionTopicsProcessor.new({request_object: request_object, course: course})
    @assignments_processor       = config[:assignments_processor] ||= Canvas::AssignmentsProcessor.new({request_object: request_object, course: course})
  end

  def call
    Canvas::PagedApiProcessor.new({request_object: request_object,
                                      handler: discussion_topics_processor}).call("api/v1/courses/#{course}/discussion_topics?per_page=250")
    Canvas::PagedApiProcessor.new({request_object: request_object,
                                      handler: assignments_processor}).call("api/v1/courses/#{course}/assignments?per_page=250")
    Activity.update_scores!
  end

end
