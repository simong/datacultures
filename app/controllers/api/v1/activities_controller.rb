class Api::V1::ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :update]

  ## TODO: only actions needed are the GET actions (index, show).  The
  ##    postgres table will be updated directly (not via API), as it will
  ##    happen within the app.  The GET endpoints are for UI layer
  ##    in-app updates are in the model layer, not the controller

  def index
    # to do scope to user
    @activities = Activity.all.order('updated_at DESC')
  end

  def show
    unless @activity
      head :no_content
    end
  end

  def create
    @activity = Activity.new(activity_params)
    begin
      if @activity.save
        render json: @activity
      end
    rescue
      head :unprocessable_entity
    end
  end

  # update is only to mark as deleted
  def update
    if @activity
      if  @activity.delete
        head :no_content
      else
        head :gone
      end
    else
      head :unprocessable_entity
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      begin
        @activity = Activity.find(params[:id])
      rescue
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_params
      params.require(:activity).permit(:canvas_scoring_item_id, :canvas_user_id, :reason, :delta)
    end
end
