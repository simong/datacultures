class Api::V1::PointsController < ApplicationController
  before_action :set_point, only: [:show, :update]

  def index
    # to do scope to user
    @points = Point.all
  end

  def show
    unless @point
      head :no_content
    end
  end

  def create
    @point = Point.new(point_params)
    begin
      if @point.save
        render json: @point
      end
    rescue
      head :unprocessable_entity
    end
  end

  # update is only to mark as deleted
  def update
    if @point
      if  @point.delete
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
    def set_point
      begin
        @point = Point.find(params[:id])
      rescue
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def point_params
      params.require(:point).permit(:uid, :reason, :delta)
    end
end
