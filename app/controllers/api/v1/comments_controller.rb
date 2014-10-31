class Api::V1::CommentsController < ApplicationController

  skip_before_filter  :verify_authenticity_token

  def create
    if Comment.create({authors_canvas_id: current_user.canvas_id, gallery_id: safe_params[:id],
                    content: safe_params[:comment] }).persisted?
      Activity.score!({reason: 'GalleryComment', delta: PointsConfiguration.cached_mappings['GalleryComment'],
                      canvas_user_id: current_user.canvas_id, scoring_item_id: safe_params[:id],
                      score: PointsConfiguration.cached_active_mappings['GalleryComment']
                      })
      head :created
    else
      head :bad_request
    end
  end

  def update
    begin
     comment = Comment.find(safe_params[:comment_id])
     if comment.update_attributes({content: safe_params[:comment] })
       head :ok
     else
       head :internal_server_error
     end
    rescue ActiveRecord::RecordNotFound
      head :gone
    end
  end

  private

  def safe_params
    params.permit(:id, :comment, :comment_id)
  end
end

