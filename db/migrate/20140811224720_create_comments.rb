class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :title
      t.integer :parent_id #comment_id of parent comment, or nil if no parent exists
      t.integer :comment_id #A number representing the n'th comment submitted so far under a specific submission. It should be unique if there is no deletions
      t.text :content
      t.integer :submission_id
      t.integer :authors_canvas_id
      t.timestamps
    end
  end
end
