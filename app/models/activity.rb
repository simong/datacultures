class Activity < ActiveRecord::Base

  belongs_to :student, primary_key: :canvas_user_id, foreign_key: :canvas_user_id
  acts_as_paranoid

  scope :opinion,                 -> { where(reason:  ['Like', 'Dislike', 'GetALike', 'GetADislike' ])}
  scope :scored,                  -> { where(score:   true)}
  scope :current,                 -> { where(expired: false)}
  scope :not_assigned_discussion, -> { where(assigned_discussion: false)}
  scope :matter,                  -> { where(assigned_discussion: false, expired: false, score: true) }

  def self.score!(activity)
    create(activity)
    # set the 'data' stale here, once caching is implemented -- use in conjunction with
    #   'time' stale (don't refresh every update but at most frequetly every 1 minute e.g.)
    #   and even then, not if there is no new activity
  end

  def self.as_csv
    matter.pluck(*FIELDS).map(&:to_csv).join()
  end

  def self.like_totals
    current.where({reason: 'Like'}).group(:scoring_item_id).count
  end

  def self.dislike_totals
    current.where({reason: 'Dislike'}).group(:scoring_item_id).count
  end

  def retire!
    update_attribute(:expired, true)
  end

  def self.student_scores
    current.scored.not_assigned_discussion.group(:canvas_user_id).sum(:delta)
  end

  def self.visible_to(user_id:, all_seeing:)
    does_user_share = Student.find_by_canvas_user_id(user_id).try(:share)
    if all_seeing
      where(true)
    else
      share_criterion = does_user_share ? Student.sharers_ids : user_id
      where(canvas_user_id: share_criterion)
    end
  end

end
