class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer     :parent_id                       # -1 for a comment directly on the asset
      t.text        :content
      t.integer     :attachment_id,      null: false
      t.integer     :authors_canvas_id,  null: false
      t.string      :author
      t.timestamps
    end
  end
end
