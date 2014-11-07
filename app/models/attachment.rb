class Attachment < ActiveRecord::Base
  acts_as_paranoid

  after_create :create_gallery_reference

  belongs_to  :assignment, primary_key: 'canvas_assignment_id', foreign_key: 'assignment_id'
  has_many :comments, :primary_key => :gallery_id, :foreign_key => :gallery_id

  def create_gallery_reference
    update_attribute(:gallery_id, generate_gallery_id)
  end

  def comments_json
    comments.map{|c| c.api_json}
  end

  def generate_gallery_id
    'image-' + id.to_s + '-' + assignment_id.to_s
  end


end
