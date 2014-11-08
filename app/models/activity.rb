class Activity < ActiveRecord::Base

  belongs_to :student
  acts_as_paranoid

  scope :opinion, -> { where(reason: ['Like', 'Dislike', 'MarkNeutral'])}
  scope :scored,  -> { where(score: true)}

  def self.score!(activity)
    create(activity)
    # set the 'data' stale here, once caching is implemented -- use in conjunction with
    #   'time' stale (don't refresh every update but at most frequetly every 1 minute e.g.)
    #   and even then, not if there is no new activity
  end

  def self.as_csv
    all.pluck(*FIELDS).map(&:to_csv).join()
  end

  def self.received_scores
    Activity.scored.group(:posters_canvas_id).sum(:delta)
  end

  def self.active_scores
    Activity.scored.group(:canvas_user_id).sum(:delta)
  end

  def self.student_scores
    self.active_scores.update(self.received_scores) { |user, active, received| active + received }
  end

  ## refresh cache
  def self.update_scores!
    self.student_scores
  end

end
