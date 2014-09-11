class Api::V1::LikesController < ApplicationController

  layout false

  # GET /api/v1/likes
  def index
    # render :text instead of :json as with :json the keys are quoted
    render json:
    {'Like' =>
       Activity.where(score: true, reason: ['Like']).group(:canvas_scoring_item_id).count.sort.to_h,
     'Dislike' =>
       Activity.where(score: true, reason: ['Dislike']).group(:canvas_scoring_item_id).count.sort.to_h
    }
  end

  # POST /api/v1/likes
  def create

    if previous_record
      head :conflict
    else
      Activity.create(item_params.merge({delta: PointsConfiguration.cached_mappings[item_params[:reason]]}))
      head :created
    end
  end

  # PUT /api/v1/likes
  # PATCH /api/v1/likes
  def update
    if previous_record
      previous_record.update_attributes item_params
      head :no_content
    else
      head :gone
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:canvas_scoring_item_id, :canvas_user_id, :reason)
    end

    def previous_record
      Activity.where(reason: ['Like', 'Dislike', 'MarkNeutral'],
                     canvas_scoring_item_id: item_params[:canvas_scoring_item_id],
                     canvas_user_id: item_params[:canvas_user_id]).first
    end

end
