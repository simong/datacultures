class Comment < ActiveRecord::Base
  validates :gallery_id, :presence => true
  belongs_to :author, primary_key: 'canvas_user_id', foreign_key: 'authors_canvas_id', class_name: 'Student'

  def api_json
    {
      'author' => {
        'name' => author.name,
        'canvas_user_id' => author.canvas_user_id
      },
      'comment_id' => id,
      'comment' => content,
      'created_at' => created_at.to_i * 1000,
    }
  end

end
