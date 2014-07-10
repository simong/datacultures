class CanvasLtiController < ApplicationController
  require 'ims/lti'
  require 'open-uri'
  skip_before_action :verify_authenticity_token, :set_x_frame_options_header
  before_action :disable_xframe_options
  helper_method :launch_url

  def embedded
    # Initialize TP object with OAuth creds and post parameters
    # provider = IMS::LTI::ToolProvider.new(@consumer_key, @consumer_secret)
    # Verify OAuth signature by passing the request object
    render
  end

  def lti_engagement_index
    respond_to :xml
  end

  def lti_points_configuration
    respond_to :xml
  end

  #GET /api/v1/courses/:course_id/users
  def students_list
    canvas_token = Rails.application.secrets.canvas_token
    course_id = params[:course_id]
    response = HTTParty.get("https://ucberkeley.test.instructure.com/api/v1/courses/#{course_id}/users?access_token=#{canvas_token}")
    render :json => response.body
  end

  # If no aquery parameters are present, returns a URL corresponding to the app server.
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

  def disable_xframe_options
    response.headers.except! 'X-Frame-Options'
  end
end
