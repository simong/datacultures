class Student < ActiveRecord::Base
  has_many :activities

  def self.ensure_student_record_exists_by_canvas_id(canvas_id)
    if Student.find_by_canvas_user_id(canvas_id).nil?
      request_object = Canvas::ApiRequest.new({base_url: AppConfig::CourseConstants.base_url, api_key: AppConfig::CourseConstants.api_key})
      profile_response = request_object.request.get('api/v1/users/'+canvas_id.to_s+'/profile')
      profile = profile_response.body
      student_data = {share: false, has_answered_share_question: false, canvas_user_id: canvas_id,
                      sis_user_id: -1, section: 'Unknown',
                      primary_email: profile['primary_email'],
                      name: profile['name'], sortable_name: profile['sortable_name'] }
      Student.create(student_data)
    end

  end


  # expire cache of students in the current course
  def self.reset_students_by_id!
  end

  # This data is very cachable
  def self.get_students_by_id
    ## using "pluck" gives the less readable [0] and [1] compared to ".id" and ".name" but it does not
    #    instantiate an ActiveRecord object for each.
    Student.all.pluck(:id, :name).inject({}){|memo, student|
       memo.merge!({student[0] => student[1]})}
  end

end
