class AddHasSharedColumnToStudent < ActiveRecord::Migration
  def change
    change_table :students do |t|
      t.boolean  :has_answered_share_question, default: false
    end
  end
end
