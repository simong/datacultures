class Activity < ActiveRecord::Base

  belongs_to :student
  acts_as_paranoid

  scope :opinion, -> { where(reason: ['Like', 'Dislike', 'MarkNeutral'])}

  def self.score!(activity)
    create(activity)
    # set the 'data' stale here, once caching is implemented -- use in conjunction with
    #   'time' stale (don't refresh every update but at most frequetly every 1 minute e.g.)
    #   and even then, not if there is no new activity
  end

  def self.liked_scores
    Activity.where({score: true}).group(:posters_canvas_id).sum(:delta)
  end

  def self.active_scores
    Activity.where({score: true}).group(:canvas_user_id).sum(:delta)
  end

  def self.student_scores
    self.active_scores.update(self.liked_scores) { |user, active, liked| active + liked }
  end

  ## refresh cache
  def self.update_scores!
    self.student_scores
  end

end
