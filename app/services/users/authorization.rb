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
      return unless @headers['Authorization']
      @headers['HTTP_AUTHORIZATION'].split(' ').last
    end
  end
end
