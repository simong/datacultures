class RemovePosterIdFromActivities < ActiveRecord::Migration
  def change
    remove_column :activities, :posters_canvas_id, :integer
  end
end
