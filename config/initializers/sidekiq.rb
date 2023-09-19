require 'sidekiq-status'
Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/3'), protocol: 2 }
  Sidekiq::Status.configure_server_middleware config, expiration: 30.minutes.to_i
  Sidekiq::Status.configure_client_middleware config, expiration: 1.hour.to_i
end
Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/6') }
  Sidekiq::Status.configure_client_middleware config, expiration: 1.hour.to_i
end
