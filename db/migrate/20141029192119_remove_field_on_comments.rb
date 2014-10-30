class RemoveFieldOnComments < ActiveRecord::Migration
  def change
    change_table :comments do |comments_table|
      comments_table.remove :author
      comments_table.remove :parent_id
      comments_table.change :attachment_id, :string
    end
  end
end
