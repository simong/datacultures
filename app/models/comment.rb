class Comment < ActiveRecord::Base
  validates :comment_id, :presence => true
  validates :submission_id, :presence => true
  validates :parent_id, :presence => true #-1 if it doesn't have a parent
  validates :comment_id, :uniqueness => {:scope => [:submission_id, :parent_id]}
  #Each comment will be unique in the combination of its (Comment_id, submission_id, and parent_id)
end
