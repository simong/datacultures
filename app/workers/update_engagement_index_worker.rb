class UpdateEngagementIndexWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { minutely }

  def perform
    conf = Rails.application.secrets['requests']
    EngagementIndexUpdateProcessor.call(conf)
  end

end
