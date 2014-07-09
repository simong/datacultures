class Api::V1::ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :update]

  def index
    # to do scope to user
    @activities = Activity.all
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
      params.require(:activity).permit(:uid, :reason, :delta)
    end
end
