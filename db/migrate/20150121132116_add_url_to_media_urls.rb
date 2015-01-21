class AddUrlToMediaUrls < ActiveRecord::Migration
  def change
    add_column :media_urls, :url, :string
  end
end
