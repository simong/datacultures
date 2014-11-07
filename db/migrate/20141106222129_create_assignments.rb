class CreateAssignments < ActiveRecord::Migration
  def change
    create_table   :assignments do |t|
      t.string     :name
      t.integer    :canvas_assignment_id
      t.datetime   :deleted_at
      t.timestamps
    end
  end
end
