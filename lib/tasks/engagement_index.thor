class EngagementIndex < Thor

  require 'thor/rails'
  include Thor::Rails

  desc "update", "Update the engagement index"

  def update
    conf = {base_url: AppConfig::CourseConstants.base_url, api_key: AppConfig::CourseConstants.api_key}
    Canvas::EngagementIndexScoringProcessor.new(conf).call
  end

end
