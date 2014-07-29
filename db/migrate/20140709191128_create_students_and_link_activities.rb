class CreateStudentsAndLinkActivities < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.integer :canvas_user_id,   :null => false #used to reference students in Canvas API, also the canvas_user_id in Activity Model
      t.string :name,          :null => false
      t.string :sortable_name, :null => false
      t.integer :sis_user_id,  :null => false
      t.string :primary_email
      t.string :section, :null => false
      t.boolean :share, :default => false

      t.timestamps
    end

  end
end
