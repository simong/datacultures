class Student < ActiveRecord::Base
  has_many :activities

  def self.aggregateFromClass(course_id)
    # get a list of students using an api call
    # GET /api/v1/courses/:course_id/users

    # fill up their data in the database
    # GET /api/v1/users/:user_id/profile
  end

end
