require 'sidekiq-status'
Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis:6379/1' }
  Sidekiq::Status.configure_server_middleware config, expiration: 30.minutes.to_i
  Sidekiq::Status.configure_client_middleware config, expiration: 1.hour.to_i
  config.logger.level = Logger::INFO
end
Sidekiq.configure_client do |config|
  config.redis = { url:  'redis://redis:6379/1' }
  Sidekiq::Status.configure_client_middleware config, expiration: 1.hour.to_i
end
