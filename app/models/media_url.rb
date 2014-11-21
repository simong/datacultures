class MediaUrl < ActiveRecord::Base
  acts_as_paranoid

  require 'string_refinement'
  using StringRefinement

  after_create :create_gallery_reference

  has_many :comments, :primary_key => :gallery_id, :foreign_key => :gallery_id
  has_one  :view, foreign_key: :gallery_id, primary_key: :gallery_id

  def create_gallery_reference
    update_attribute(:gallery_id, generate_gallery_id)
  end

  def comments_json
    comments.map{|c| c.api_json}
  end

  def generate_gallery_id
    'video-' + id.to_s + '-' + canvas_assignment_id.to_s
  end

  def views_count
    view.nil? ? 0 : view.views
  end

end
