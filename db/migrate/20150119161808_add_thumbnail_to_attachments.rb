class AddThumbnailToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :thumbnail_url, :string
  end
end
