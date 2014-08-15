def retrieve_canvas_students()
  # if we are in the test environment or the request array doesn't exist, don't run script
  course_id = Rails.application.secrets['requests']['course']
  base_url = Rails.application.secrets['requests']['base_url']
  api_key = Rails.application.secrets['requests']['api_keys']['teacher']
  begin
    response = Canvas::ApiRequest.new({base_url:  base_url, api_key: api_key}).request.get("api/v1/courses/#{course_id}/search_users")
    users_list_json = response.body
    status = response.status
  rescue
    users_list_json = {"errors" => true}
  end
  unless status != 200 || users_list_json.first.first == "errors" #If the Canvas API doesn't return a 200, data should not be read in
    users_list_json.each do |user|
      user_attributes = {}
      user_attributes[:name] = user["name"]
      user_attributes[:sortable_name] = user["sortable_name"]
      user_attributes[:canvas_user_id] = user["id"].to_i
      user_attributes[:sis_user_id] = user["sis_user_id"] || -1
      user_attributes[:share] = false
      user_attributes[:section] = "Unknown"

      # we can't use #find_or_create_by as if any other attributes differ but canvas_user_id value is already
      # present, ActiveRecord will not match, and will try to create a new record, violating uniqueness on that key.
      student = Student.where({canvas_user_id: user_attributes[:canvas_user_id]}).first
      if student.nil?
        Student.create(user_attributes)
      else
        # pickup any changes from Canvas
        student.update_attributes(user_attributes)
      end
    end
  end
end

if !Rails.env.test? && Rails.application.secrets['requests'] && ActiveRecord::Base.connection.table_exists?('students')
  retrieve_canvas_students()
end

