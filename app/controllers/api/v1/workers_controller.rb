class Api::V1::WorkersController < ApplicationController

  before_filter :ensure_valid_api_key

  # POST /api/v1/workers
  def create
    case safe_params[:worker_type]
      when 'discussions'
        DiscussionUpdateWorker.perform_async(AppConfig::ProcessingConstants.datacultures_api_url,
                                             AppConfig::CourseConstants.course)
      when 'assignments'
        AssignmentUpdateWorker.perform_async(AppConfig::ProcessingConstants.datacultures_api_url,
                                             AppConfig::CourseConstants.course)
      # else log error -- one of those params should *always* be supplied
    end
  end

  private

  def safe_params
    params.permit(:worker_type)
  end

  def ensure_valid_api_key
    request.headers.include? 'Authorization' &&
    request.headers['Authorization'] == 'Bearer ' + AppConfig::ProcessingConstants.datacultures_api_key
  end

end
