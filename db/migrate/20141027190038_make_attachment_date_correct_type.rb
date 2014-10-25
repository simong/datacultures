class MakeAttachmentDateCorrectType < ActiveRecord::Migration
  def change
    remove_column  :attachments, :date, :string
    add_column :attachments, :date, :datetime
  end
end
