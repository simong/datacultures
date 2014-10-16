class CreateMediaUrls < ActiveRecord::Migration
  def change
    create_table   :media_urls do |t|
      t.string     :site_tag   # e.g., 'youtube_id' or 'vimeo_id'
      t.string     :site_id    #  'qObzgUfCl28'
      t.integer    :canvas_user_id
      t.integer    :canvas_assignment_id
      t.string     :author
      t.datetime   :deleted_at
      t.timestamps
    end
  end
end
