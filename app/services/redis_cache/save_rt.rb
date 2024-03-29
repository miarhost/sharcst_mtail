module RedisCache
  class SaveRt  < ApplicationService
    include RedisClient
    def initialize(token, refresh_token, user_id)
      @token = token
      @ttl = ttl
      @refresh_token = refresh_token
    end

    def call
      redis.hmset(@token, 'userId', @user_id.to_s, 'refreshToken', @refresh_token, 'ttl', ttl)
    end

    def ttl
      (Time.now.to_i + ENV['REFRESH_TTL'].to_i).to_s
    end
  end
end
