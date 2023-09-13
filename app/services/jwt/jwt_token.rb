require 'jwt'
module Jwt
  class JwtToken
    def self.encode(payload)
      JWT.encode(payload, ENV['JWT_HMAC'], ENV['JWT_ALG'])
    end

    def self.decode(token)
      JWT.decode(token, ENV['JWT_HMAC'], true, { algorithm: ENV['JWT_ALG'] })
    rescue JWT::ExpiredSignature => e
      { "error": e.message }
    end
  end
end
