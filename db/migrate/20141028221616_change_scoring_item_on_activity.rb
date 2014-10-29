class ChangeScoringItemOnActivity < ActiveRecord::Migration
  def change
    rename_column :activities, :canvas_scoring_item_id, :scoring_item_id
    change_column :activities, :scoring_item_id, :string
  end
end
