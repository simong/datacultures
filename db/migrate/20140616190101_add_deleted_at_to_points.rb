class AddDeletedAtToPoints < ActiveRecord::Migration
  def change
    add_column :points, :deleted_at, :datetime
    add_index :points, :deleted_at
  end
end
