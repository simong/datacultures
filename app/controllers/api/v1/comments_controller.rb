class Api::V1::CommentsController < ApplicationController

  skip_before_filter  :verify_authenticity_token

  require 'string_refinement'
  using StringRefinement

  def create
    if Comment.create({authors_canvas_id: current_user.canvas_id, gallery_id: safe_params[:id],
                       content: safe_params[:comment] }).persisted?
      base_poster = original_poster_id
      if (base_poster.to_s != current_user.canvas_id.to_s)
        Activity.score!(values_for_create(user_id: base_poster,            activity_type: 'GetAComment'))
        Activity.score!(values_for_create(user_id: current_user.canvas_id, activity_type: 'GalleryComment'))
      end
      head :created
    else
      head :bad_request
    end
  end

  def update
    begin
     comment = Comment.find(safe_params[:comment_id])
     if comment.update_attributes({content: safe_params[:comment] })
       head :no_content
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

  def values_for_create(user_id:, activity_type:)
    # self-commenting does not credit the commenter
    {
        canvas_user_id: user_id,
        reason: activity_type,
        scoring_item_id: safe_params[:id],
        canvas_updated_at: Time.now,
        delta: PointsConfiguration.cached_mappings[activity_type],
        score: PointsConfiguration.active_flag_mappings[activity_type]
    }
  end

  def original_poster_id
    safe_params[:id].gallery_model_class.where(gallery_id: safe_params[:id]).
        first.try(:canvas_user_id)
  end

end

