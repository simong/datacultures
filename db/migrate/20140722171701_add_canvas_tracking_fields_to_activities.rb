class AddCanvasTrackingFieldsToActivities < ActiveRecord::Migration
  def change
    change_table :activities do |t|
      t.remove     :uid
      t.integer    :canvas_user_id
      t.integer    :canvas_scoring_item_id, null: false
      t.datetime   :canvas_updated_at
      t.index     [:canvas_scoring_item_id, :reason]
      t.text       :body
    end

    change_column_null :activities, :canvas_user_id, false

  end
end
