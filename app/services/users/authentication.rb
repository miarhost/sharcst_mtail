module Users
  class Authentication < ApplicationService
    def initialize(email, password)
      @email = email
      @password = password
      @token = ''
    end

    def user
      User.find_by!(email: @email)
    end

    def call
      attach_token
    end

    def attach_token
      @token = Jwt::JwtToken.encode(user) if user && user.password == @password
      @token
    end

    def current_user_id
      return if @token.blank?

      Jwt::JwtToken.decode(@token)[0].deep_symbolize_keys[:user][:id]
    end
  end
end
