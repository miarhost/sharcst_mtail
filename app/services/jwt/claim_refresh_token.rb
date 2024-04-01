require 'jwt'
module Jwt
  class ClaimRefreshToken < Jwt::JwtToken
    def self.decode(token)
      super
    rescue JWT::ExpiredSignature => e
      raise Errors::ErrorsHandler::ExpirationRefreshTokenError, e.message
    end
  end
end
