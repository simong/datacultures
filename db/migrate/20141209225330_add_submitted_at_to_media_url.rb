class AddSubmittedAtToMediaUrl < ActiveRecord::Migration
  def change
    add_column :media_urls, :submitted_at, :datetime
  end
end
