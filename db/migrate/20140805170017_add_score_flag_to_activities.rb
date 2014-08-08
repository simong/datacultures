class AddScoreFlagToActivities < ActiveRecord::Migration
  def change
    change_table :activities do |t|
      t.boolean  :score
    end
  end
end
