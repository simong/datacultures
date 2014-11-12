class Activity < ActiveRecord::Base

  belongs_to :student, primary_key: :canvas_user_id, foreign_key: :canvas_user_id
  acts_as_paranoid

  scope :opinion, -> { where(reason:  ['Like', 'Dislike', 'GetALike', 'GetADislike' ])}
  scope :scored,  -> { where(score:   true)}
  scope :current, -> { where(expired: false)}

  def self.score!(activity)
    create(activity)
    # set the 'data' stale here, once caching is implemented -- use in conjunction with
    #   'time' stale (don't refresh every update but at most frequetly every 1 minute e.g.)
    #   and even then, not if there is no new activity
  end

  def self.as_csv
    current.scored.pluck(*FIELDS).map(&:to_csv).join()
  end

  def retire!
    update_attribute(:expired, true)
  end

  def self.student_scores
    current.scored.group(:canvas_user_id).sum(:delta)
  end


  ## refresh cache
  def self.update_scores!
    self.student_scores
  end

end
