class AddPostersCanvasIdToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :posters_canvas_id, :integer
  end
end
