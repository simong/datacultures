class MakeCanvasUserIdUnique < ActiveRecord::Migration
  def change
    add_index :students, :canvas_user_id, :unique => true
  end
end
