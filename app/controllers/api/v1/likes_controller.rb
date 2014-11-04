class Api::V1::LikesController < ApplicationController

  layout false

  # POST /api/v1/likes
  def create_or_update
    if previous_record
      previous_record.update_attributes values_for_update
      head :no_content
    else
      Activity.create(values_for_create)
      head :created
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def safe_params
      params.permit(:liked, :id)
    end

    def  values_for_update
      {
        reason: reason,
        canvas_updated_at: Time.now,
        delta: PointsConfiguration.cached_mappings[reason]
      }
    end

    def values_for_create
      if safe_params[:id] =~ /image-/
        model = Attachment
      else
        model = MediaUrl
      end
      posting_users_canvas_id = model.where(gallery_id: safe_params[:id]).
          first.try(:canvas_user_id)
      {
          canvas_user_id: current_user.canvas_id,
          reason: reason,
          scoring_item_id: safe_params[:id],
          canvas_updated_at: Time.now,
          delta: PointsConfiguration.cached_mappings[reason],
          score: PointsConfiguration.active_flag_mappings[reason],
          posters_canvas_id: posting_users_canvas_id
      }
    end

    def reason
      case safe_params[:liked]
        when true
          'Like'
        when false
          'Dislike'
        else
          'MarkNeutral'
      end
    end

    def previous_record
      Activity.where(reason: ['Like', 'Dislike', 'MarkNeutral'],
                     scoring_item_id: safe_params[:id],
                     canvas_user_id: current_user.canvas_id).first
    end

end
