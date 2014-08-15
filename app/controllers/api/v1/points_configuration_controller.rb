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
  # TODO: method too big, refactor it
  def update
    point_config_data = params['_json']
    all_pcids = PointsConfiguration.all.select(:pcid).map{|pc| pc.pcid}
    returned_pcids = point_config_data.map{|pc| pc['id'].to_s}
    missing_pcids = all_pcids - returned_pcids
    point_config_data.each do |pc|
      p = PointsConfiguration.where({pcid: pc['id'].to_s}).first
      if !p.active? || (p.points_associated != pc['points'])
        p.update_attributes({points_associated: pc['points'], active: true})
        Activity.where({reason: p.interaction}).update_all({score: true, delta: pc['points']})
      end
    end
    missing_pcids.each do |pc|
      p = PointsConfiguration.where({pcid: pc}).first
      if p.active?
        p.update_attribute(:active, false)
        Activity.where({reason: p.interaction}).update_all(score: false)  # no point value changes for inactive activities
      end
    end
    head :ok
  end

end
