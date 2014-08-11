class Comment < ActiveRecord::Base
  validates :comment_id, :uniqueness => {:scope => [:submission_id, :parent_id]}
end
