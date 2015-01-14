class Canvas::StudentsProcessor

  attr_accessor :request_object

  def initialize(conf)
    @request_object = conf[:request_object] || ApiRequest.new(api_key: conf[:api_key], base_url: conf[:base_url])
  end

  def call(students)
    if students.respond_to?(:each)
      students.each do |student|
        student_attributes = {}
        student_attributes[:name] = student["name"]
        student_attributes[:sortable_name] = student["sortable_name"]
        student_attributes[:canvas_user_id] = student["id"].to_i
        student_attributes[:sis_user_id] = student["sis_user_id"] || -1
        student_attributes[:section] = "Unknown"

        # we can't use #find_or_create_by as if any other attributes differ but canvas_user_id value is already
        # present, ActiveRecord will not match, and will try to create a new record, violating uniqueness on that key.
        student_record = Student.where({canvas_user_id: student_attributes[:canvas_user_id]}).first
        if student_record.nil?
          Student.create(student_attributes)
        else
          student_record.update_attributes(student_attributes)
        end
      end
    end
  end
end
