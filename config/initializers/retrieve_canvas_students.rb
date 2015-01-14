def retrieve_canvas_students()
  # if we are in the test environment or the request array doesn't exist, don't run script
  course_id = AppConfig::CourseConstants.course
  base_url = AppConfig::CourseConstants.base_url
  api_key = AppConfig::CourseConstants.api_key
  begin
    request_object = ApiRequest.new(base_url:  base_url, api_key: api_key)
    Canvas::PagedApiProcessor.new({request_object: request_object,
                                   handler: Canvas::StudentsProcessor.new({request_object: request_object})}).call("api/v1/courses/#{course_id}/search_users?per_page=250")
  end
end

def have_needed_config?
  !AppConfig::CourseConstants.base_url.nil? && !AppConfig::CourseConstants.api_key.nil? && !AppConfig::CourseConstants.course.nil?
end

if !Rails.env.test? && have_needed_config? && ActiveRecord::Base.connection.table_exists?('students')
  retrieve_canvas_students()
end
