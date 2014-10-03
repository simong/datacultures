class Comment < ActiveRecord::Base
  validates :attachment_id, :presence => true
  validates :parent_id, :presence => true #-1 if it doesn't have a parent
end
