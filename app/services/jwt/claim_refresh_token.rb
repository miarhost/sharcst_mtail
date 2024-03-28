  require 'jwt'
  class ClaimRefreshToken < JwtToken
    def self.decode(token)
      super
    rescue JWT::ExpiredSignature => e
      Errors::ErrorsHandler::ExpirationRefreshTokenError, e.message
    end
  end
