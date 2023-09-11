module Users
  class Authentication < ApplicationService
    def initialize(email, password)
      @email = email
      @password = password
    end

    def user
      User.find_by(email: @email)
    end

    def call
      attach_token
    end

    def attach_token
      Jwt::JwtAuth.new(user).generate_token if user&.authenticate(@password)
    end
  end
end
