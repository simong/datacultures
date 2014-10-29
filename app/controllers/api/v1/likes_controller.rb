class Api::V1::LikesController < ApplicationController

  layout false

  # GET /api/v1/likes
  def index
    # render :text instead of :json as with :json the keys are quoted
    render json:
    {'Like' =>
       Activity.where(score: true, reason: ['Like']).group(:scoring_item_id).count.sort.to_h,
     'Dislike' =>
       Activity.where(score: true, reason: ['Dislike']).group(:scoring_item_id).count.sort.to_h
    }
  end

  # POST /api/v1/likes
  def create_or_update
    if previous_record
      previous_record.update_attributes create_or_update_values
      head :no_content
    else
      Activity.create(create_or_update_values)
      head :created
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def safe_params
      params.permit(:liked, :id)
    end

    def create_or_update_values
      { canvas_user_id: current_user.canvas_id,
        reason: reason,
        scoring_item_id: safe_params[:id],
        canvas_updated_at: Time.now,
        delta: PointsConfiguration.cached_mappings[reason]
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
