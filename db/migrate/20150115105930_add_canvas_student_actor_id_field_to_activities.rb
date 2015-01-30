class AddCanvasStudentActorIdFieldToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :canvas_user_actor_id, :integer
  end
end
