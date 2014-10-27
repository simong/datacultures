class Student < ActiveRecord::Base
  has_many :activities

  require 'array_refinement'
  using ArrayRefinement

  DEFAULT_USER_ATTRIBUTES = { share: false, has_answered_share_question: false,
                              sis_user_id: -1, section: 'Unknown'}
  USER_PROFILE_FIELDS     =  %w{name sortable_name primary_email}   # fields used from the /api/v1/users/:id/profile call

  # expire cache of students in the current course
  def self.reset_students_by_id!
  end

  # This data is very cachable
  def self.get_students_by_canvas_id
    ## using "pluck" gives the less readable [0] and [1] compared to ".id" and ".name" but it does not
    #    instantiate an ActiveRecord object for each.
    Student.all.pluck(:canvas_user_id, :name).inject({}){|memo, student|
      memo.merge!({student[0] => student[1]})}
  end

  # unlike the case for ::ensure_student_record_exists we do not have enough data, and so require
  #   an API call
  def self.create_by_canvas_user_id(canvas_user_id)
    if canvas_user_id && where({canvas_user_id: canvas_user_id}).empty?
      requester = ApiRequest.new(base_url: AppConfig::CourseConstants.base_url,
                                          api_key: AppConfig::CourseConstants.api_key)
      student_data = requester.request.get('api/v1/users/'+canvas_user_id.to_s+'/profile').body
      creation_data = student_data.slice(*USER_PROFILE_FIELDS)
          .merge('canvas_user_id' => canvas_user_id)
          .merge(DEFAULT_USER_ATTRIBUTES)
      Student.create(creation_data)
    end
  end

  # make sure the Student record exists, and is up to date.  params hash has given us enough data to
  #   create the record
  def self.ensure_student_record_exists(params)
    # canvas_user_id *is* specific, but cannot change for the Student and so is ignored in those hashes
    sortable_user_name = [params['lis_person_name_family'], params['lis_person_name_given']].name_sortable
    new_specifics      = [params, sortable_user_name].personal_data
    existing_student = Student.find_by_canvas_user_id(params["custom_canvas_user_id"])
    if (existing_student.nil?)
      Student.create(self.full_student_data(new_specifics, params))
    else
      existing_student.update_if_needed(new_specifics)
    end
  end

  def self.full_student_data(new_specifics, params)
    full_student_data = DEFAULT_USER_ATTRIBUTES.merge(new_specifics).merge({canvas_user_id: params["custom_canvas_user_id"]})
  end

  def update_if_needed(new_specifics)
    existing_specifics = {name: name, primary_email: primary_email, sortable_name: sortable_name}
    if (new_specifics.symbolize_keys != existing_specifics)
      update_attributes(new_specifics)
    end
  end

  # update other records where name has been copied.
  def update_other_tables(new_attributes)
    # Comments should use new name value
    Comment.where({authors_canvas_id: new_attributes[:canvas_user_id]}).update_all({author: new_attributes[:name]})
  end

end
