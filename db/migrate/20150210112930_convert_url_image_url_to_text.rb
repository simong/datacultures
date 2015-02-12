class ConvertUrlImageUrlToText < ActiveRecord::Migration
  def change
    change_column :generic_urls, :url, :text
    change_column :generic_urls, :image_url, :text
  end
end
