class Activity < ActiveRecord::Base
  belongs_to :student
  acts_as_paranoid

  def self.score!(activity)
    create(activity)
  end

end
