class AddThumbnailUrlToGenericUrls < ActiveRecord::Migration
  def change
    add_column :generic_urls, :thumbnail_url, :string
  end
end
