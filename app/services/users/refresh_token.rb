module Users
  class RefreshToken < ApplicationService
    include IssueTokens
    def initialize(token)
      @token = token
    end

    def user
      user_id = Jwt::ClaimRefreshToken.decode(@token)[0].deep_symbolize_keys[:user_id].to_i
      User.find(user_id)
    end

    def call
      attach_tokens(user)
    end
  end
end
