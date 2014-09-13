class UpdateEngagementIndexWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { minutely }

  def perform
    conf = {base_url: AppConfig::CourseConstants.base_url, api_key: AppConfig::CourseConstants.api_key}
    Canvas::EngagementIndexScoringProcessor.new(conf).call
  end

end
