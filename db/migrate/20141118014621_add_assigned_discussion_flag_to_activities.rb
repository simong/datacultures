class AddAssignedDiscussionFlagToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :assigned_discussion, :boolean, default: false
  end
end
