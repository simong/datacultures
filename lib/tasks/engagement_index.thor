class EngagementIndex < Thor

  require 'thor/rails'
  include Thor::Rails

  desc "print", "Print Rails env"

  def print_env
    puts ENV['RAILS_ENV']
  end

  desc "update", "Update the engagement index"

  def update
    conf = {base_url: AppConfig::CourseConstants.base_url, api_key: AppConfig::CourseConstants.api_key}
    Canvas::EngagementIndexScoringProcessor.new(conf).call
  end

end
