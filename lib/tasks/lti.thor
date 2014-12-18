class Lti < Thor

  require 'thor/rails'
  include Thor::Rails

  desc "add_gallery", "add the Gallery component"
  def add_gallery
    add_component(name: 'Gallery', url: 'canvas/lti_gallery')
  end

  desc "add_engagement_index", "add the Engagement Index"
  def add_engagement_index
    add_component(name: 'Engagement Index', url: 'canvas/lti_engagement_index')
  end

  desc "add_points_configuration", "add the Points Configuration component"
  def add_points_configuration
    add_component(name: 'Points Configuration', url: 'canvas/lti_points_configuration')
  end

  desc "add_all_tools", "add all 3 tools (Gallery, Engagement Index, Points Configuration"
  def add_all_tools
    add_component(name: 'Gallery', url: 'canvas/lti_gallery')
    add_component(name: 'Points Configuration', url: 'canvas/lti_points_configuration')
    add_component(name: 'Engagement Index', url: 'canvas/lti_engagement_index')
  end

  private
  def add_component(name:, url:)
    request_body   = { 'consumer_key' => AppConfig::CourseConstants.lti_key, 'shared_secret' => AppConfig::CourseConstants.lti_secret,
                     'config_type' => 'by_url', 'config_url' =>  AppConfig::CourseConstants.lti_base_url + url, 'name' => name}
    post_url       =  AppConfig::CourseConstants.base_url + 'api/v1/courses/' +  AppConfig::CourseConstants.course + '/external_tools'
    request_object = ApiRequest.new({api_key:  AppConfig::CourseConstants.api_key, base_url:  AppConfig::CourseConstants.base_url})
    request_object.request.post post_url, request_body
  end

end
