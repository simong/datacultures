class CanvasLtiController < ApplicationController
  #require 'ims/lti'
  require 'open-uri'
  require 'oauth/request_proxy/rack_request'
  skip_before_action :verify_authenticity_token, :set_x_frame_options_header
  before_action :disable_xframe_options
  helper_method :launch_url

  def embedded
    consumer_key = AppConfig::CourseConstants.lti_key
    consumer_secret = AppConfig::CourseConstants.lti_secret
    provider = IMS::LTI::ToolProvider.new(consumer_key, consumer_secret, params)
    # Verify OAuth signature by passing the request object
    if provider.valid_request?(request)
      populate_session
      Student.ensure_student_record_exists(params)
      render
    else
      # handle invalid OAuth
      # policy not yet set
    end
  end

  def lti_engagement_index
    respond_to :xml
  end

  def lti_points_configuration
    respond_to :xml
  end

  def lti_gallery
    respond_to :xml
  end

  # If no query parameters are present, returns a URL corresponding to the app server.
  # If 'app_host' is specified, then the URL points to the app_host server.
  # Example: https://calcentral.berkeley.edu/canvas/lti_roster_photos.xml?app_host=sometestsystem.berkeley.edu
  def launch_url(app_name)
    if params["app_host"]
      "https://#{params['app_host']}/canvas/embedded/#{app_name}"
    else
      url_for(only_path: false, action: 'embedded', url: app_name)
    end
  end

  private

  def populate_session
    session[:canvas] = {
      'canvas_id' => params['custom_canvas_user_id'],  'family_name' => params['lis_person_name_family'],
      'given_name' => params['lis_person_name_given'], 'course_id' => params['custom_canvas_course_id'],
      'roles' => params['roles'].split(',').map{|s| s.split('/').last}, 'user_name' => params['lis_person_name_full'],
      'primary_email' => params['lis_person_contact_email_primary']
    }
  end

  def disable_xframe_options
    response.headers.except! 'X-Frame-Options'
  end
end
