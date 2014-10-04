class Activity < ActiveRecord::Base

  belongs_to :student
  acts_as_paranoid

  ## TODO: when multicourse support is added, turn this into a hash of hashes; top key is course_id
  @@scores = nil

  def self.score!(activity)
    create(activity)
    # set the data stale here, once caching is implemented
  end

  ## this is where the cache is refreshed, once caching is implemented
  def self.update_scores!
    # @@scores =
    Activity.where({score: true}).group(:canvas_user_id).sum(:delta)
  end

  def self.student_scores
    self.update_scores! # unless @@scores
    # @@scores
  end

end
