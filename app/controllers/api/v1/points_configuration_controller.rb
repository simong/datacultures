class Api::V1::PointsConfigurationController < ApplicationController

  skip_before_filter  :verify_authenticity_token

  # GET #index
  def index
    human_names = I18n.t 'activity_types'
    points_configuration = PointsConfiguration.all.inject([]){|a, pc| a << {id: pc.pcid.to_i,
         name: human_names[pc.interaction.to_sym], active: pc.active, points: pc.points_associated}}
    render json: {"activities" => points_configuration}
  end


  # POST #update
  def update
    point_config_data = params['_json']
    all_pcids = PointsConfiguration.all.select(:pcid).map{|pc| pc.pcid}
    returned_pcids = point_config_data.map{|pc| pc['id'].to_s}
    missing_pcids = all_pcids - returned_pcids
    point_config_data.each do |pc|
      PointsConfiguration.where({pcid: pc['id'].to_s}).first.update_attributes({points_associated: pc['points'], active: true})
    end
    missing_pcids.each do |pc|
      PointsConfiguration.where({pcid: pc}).first.update_attribute(:active, false)
    end
    head :ok
  end

end
