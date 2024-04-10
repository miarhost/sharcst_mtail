module Users
  class  Authorization < ApplicationService
    def initialize(headers)
      @headers = headers
    end

    def call
      current_user
    end

    def current_user
      @current_user = User.find(decoded_token)
    end

    def track_login
      current_user.update!(remember_created_at: Time.now, login_count: current_user.login_count + 1)
    end

    private

    def decoded_token
      decoded =
    begin
      Jwt::JwtToken.decode(token)
    rescue
      jwt_token = Jwt::JwtToken.refresh_token(token)
      Jwt::JwtToken.decode(jwt_token[:jwt_token])
    end
      decoded[0].deep_symbolize_keys[:user][:id]
    end

    def token
      @headers['HTTP_AUTHORIZATION'].split(' ').last
    end
  end
end
