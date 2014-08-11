class UpdateEngagementIndexWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { minutely }

  def perform
    conf = Rails.application.secrets['requests']
    Canvas::EngagementIndexScoringProcessor.new(conf.symbolize_keys).call
  end

end
