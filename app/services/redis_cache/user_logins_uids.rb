
class RedisCache::UserLoginsUids < ApplicationService

  def call
    result = Update::PopulateUidsWorker.perform_async
     sleep 5
    Sidekiq::Status.get(result, :result)
  end
end
