class CreatePointsConfigurations < ActiveRecord::Migration
  def change
    create_table :points_configurations do |t|
      t.string "pcid",               null: false
      t.string "interaction",        null: false
      t.integer "points_associated", null: false
      t.boolean "active",            default: true
      t.timestamps
    end
  end
end
