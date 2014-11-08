class Api::V1::CommentsController < ApplicationController

  skip_before_filter  :verify_authenticity_token

  def create
    if Comment.create({authors_canvas_id: current_user.canvas_id, gallery_id: safe_params[:id],
                       content: safe_params[:comment] }).persisted?
      base_poster = original_poster_id
      if (base_poster != current_user.canvas_id)
        Activity.score!(values_for_create(item_poster_id: base_poster))
      end
      head :created
    end
  else
    head :bad_request
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

  def values_for_create(item_poster_id:)
    # self-commenting does not credit the commenter
    {
        canvas_user_id: current_user.canvas_id,
        reason: 'GalleryComment',
        scoring_item_id: safe_params[:id],
        canvas_updated_at: Time.now,
        delta: PointsConfiguration.cached_mappings['GalleryComment'],
        score: PointsConfiguration.active_flag_mappings['GalleryComment'],
        posters_canvas_id: item_poster_id
    }
  end

  def original_poster_id
    if safe_params[:id] =~ /image-/
      model = Attachment
    else
      model = MediaUrl
    end
    model.where(gallery_id: safe_params[:id]).
        first.try(:canvas_user_id)
  end

end

