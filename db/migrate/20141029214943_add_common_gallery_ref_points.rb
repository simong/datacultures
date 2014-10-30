class AddCommonGalleryRefPoints < ActiveRecord::Migration
  def change
    rename_column :comments,    :attachment_id, :gallery_id
    add_column    :media_urls,  :gallery_id,    :string
    add_column    :attachments, :gallery_id,    :string
    add_column    :activities,  :gallery_id,    :string
  end
end
