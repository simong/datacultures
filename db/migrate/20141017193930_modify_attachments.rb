class ModifyAttachments < ActiveRecord::Migration
  def change

    change_table :attachments do |attachments_table|
      attachments_table.rename :url, :image_url
    end

  end
end
