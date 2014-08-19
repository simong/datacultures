class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer  :canvas_user_id, :assignment_id, :submission_id, :attachment_id
      t.string   :author, :date, :content_type
      t.text     :url
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
