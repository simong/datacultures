class PointsConfigurationController < ApplicationController

  skip_before_filter  :verify_authenticity_token

  def update_all
    points_configuration_json =  params[:_json]
    PointsConfiguration.update(points_configuration_json)
    head :ok
  end

end
