class Activity < ActiveRecord::Base

  belongs_to :student
  acts_as_paranoid

  def self.score!(activity)
    create(activity)
    # set the 'data' stale here, once caching is implemented -- use in conjunction with
    #   'time' stale (don't refresh every update but at most frequetly every 1 minute e.g.)
    #   and even then, not if there is no new activity
  end

  ## refresh cache
  def self.update_scores!
    Activity.where({score: true}).group(:canvas_user_id).sum(:delta)
  end

  ## return cached scores
  def self.student_scores
    self.update_scores!
  end

end
