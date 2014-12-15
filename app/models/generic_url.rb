class GenericUrl < ActiveRecord::Base

  acts_as_paranoid

  after_create :create_gallery_reference

  def create_gallery_reference
    update_attribute(:gallery_id, generate_gallery_id)
  end

  def generate_gallery_id
    'url-' + id.to_s + '-' + assignment_id.to_s
  end

end
