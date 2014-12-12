class CreateGenericUrls < ActiveRecord::Migration
  def change
    create_table    :generic_urls do |t|
      t.integer     :assignment_id
      t.integer     :canvas_user_id
      t.string      :gallery_id
      t.string      :url
      t.string      :image_url
      t.timestamp   :submitted_at
      t.timestamp   :deleted_at
      t.timestamps
    end
  end
end
