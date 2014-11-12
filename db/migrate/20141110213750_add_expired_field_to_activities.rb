class AddExpiredFieldToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :expired, :boolean, default: false
  end
end
