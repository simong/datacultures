class Student < ActiveRecord::Base
  has_many :activities

  @@students_by_id = nil

  def self.aggregateFromClass(course_id)
    # get a list of students using an api call
    # GET /api/v1/courses/:course_id/users

    # fill up their data in the database
    # GET /api/v1/users/:user_id/profile
  end

  def self.reset_students_by_id!
    @@students_by_id = nil
  end

  def self.get_students_by_id
    ## using "pluck" gives the less readable [0] and [1] compared to ".id" and ".name" but it does not
    #    instantiate an ActiveRecord object for each.
    @@students_by_id = @@students_by_id || Student.all.pluck(:id, :name).inject({}){|memo, student|
       memo.merge!({student[0] => student[1]})}
  end

end
