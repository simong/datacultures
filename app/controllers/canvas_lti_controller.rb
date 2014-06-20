class CanvasLtiController < ApplicationController
  require 'ims/lti'
  skip_before_action :verify_authenticity_token, :set_x_frame_options_header
  before_action :disable_xframe_options
  helper_method :launch_url

  def embedded
    # Initialize TP object with OAuth creds and post parameters
    # provider = IMS::LTI::ToolProvider.new(@consumer_key, @consumer_secret)
    # Verify OAuth signature by passing the request object
    render
  end

  def lti_leaderboard
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

  def disable_xframe_options
    response.headers.except! 'X-Frame-Options'
  end
end
