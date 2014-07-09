class RenamePointsToActivities < ActiveRecord::Migration
  def self.up
    rename_table :points, :activities
  end

  def self.down
    rename_table :activities, :points
  end
end
