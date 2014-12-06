# Reduce logging for sidekiq in production:

if Rails.env == 'production'
  Sidekiq::Logging.logger.level = Logger::WARN
end
