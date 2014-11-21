class AddThumbnailUrlToMediaUrls < ActiveRecord::Migration
  def change
    add_column :media_urls, :thumbnail_url, :string
  end
end
