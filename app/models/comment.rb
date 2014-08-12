class Comment < ActiveRecord::Base
  validates :comment_id, :presence => true
  validates :submission_id, :presence => true
  validates :parent_id, :presence => true
  validates :comment_id, :uniqueness => {:scope => [:submission_id, :parent_id]}
end
