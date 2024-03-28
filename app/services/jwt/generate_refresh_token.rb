require 'jwt'
module Jwt
  class GenerateRefreshToken
    def self.call(user)
      Jwt::JwtToken.encode(
        exp:     Time.now.to_i + ENV['REFRESH_TTL'],
        iat:     Time.now.to_i,
        user_id: user.id.to_s
      )
    end
  end
end
