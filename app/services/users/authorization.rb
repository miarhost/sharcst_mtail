module Users
class  Authorization < ApplicationService
  def initialize(headers)
    @headers = headers
  end

  def call
    current_user
  end

  def current_user
    @current_user = User.find(decoded_token) if decoded_token
  end

    private

    def decoded_token
      token = @headers['HTTP_AUTHORIZATION'].split(' ').last
      Jwt::JwtToken.decode(token)[0].deep_symbolize_keys[:user][:id]
    end
  end
end
