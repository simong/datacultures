class Comment < ActiveRecord::Base
  validates :gallery_id, :presence => true
  belongs_to :author, primary_key: 'canvas_user_id', foreign_key: 'authors_canvas_id', class_name: 'Student'

  def api_json
    { 'author' => { 'name' => author.name },
      'comment_id' => id,
      'comment' => content
    }
  end

end
