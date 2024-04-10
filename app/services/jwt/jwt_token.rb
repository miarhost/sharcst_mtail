require 'jwt'
module Jwt
  class JwtToken
    def self.encode(payload)
      JWT.encode(payload, ENV['JWT_HMAC'], ENV['JWT_ALG'])
    end

    def self.decode(token)
      JWT.decode(token, ENV['JWT_HMAC'], true, { algorithm: ENV['JWT_ALG'] })
    end

    def self.refresh_token(token)
      rt_token = RedisCache::FetchRt.call(token)
      Users::RefreshToken.call(rt_token)
    end
  end
end
