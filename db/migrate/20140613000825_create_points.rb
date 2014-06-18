class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.string  :uid,    :null => false
      t.string  :reason, :null => false
      t.integer :delta,  :null => false
      t.timestamps
    end
  end
end
