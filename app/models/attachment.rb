class Attachment < ActiveRecord::Base
  acts_as_paranoid

  after_create :create_gallery_reference

  has_many :comments, :primary_key => :gallery_id, :foreign_key => :gallery_id

  def create_gallery_reference
    update_attribute(:gallery_id, id.to_s+'-'+assignment_id.to_s)
  end

  def comments_json
    comments.map{|c| c.api_json}
  end

end
