class Activity < ActiveRecord::Base
  acts_as_paranoid

  def self.score!(activity)
    create(activity)
  end

end
