module Jwt
  class JwtAuth
    attr_accessor :token
    def initialize(user)
      @user = user
    end

    def payload
      {
        sub: 'User',
        exp: Time.now.to_i + ENV['JWT_TTL'].to_i,
        iat: Time.now.to_i,
        user: {
          id: @user.id,
          email: @user.email
        }
      }
    end

    def generate_token
      @token = Jwt::JwtToken.encode(payload)
    end
  end
end
