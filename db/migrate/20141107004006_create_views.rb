class CreateViews < ActiveRecord::Migration
  def change
    create_table :views do |t|
      t.string :gallery_id
      t.integer :views,  default: 0
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
