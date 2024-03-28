module User
  class RefreshToken < ApplicationService
    include IssueTokens
    def initialize(token)
      @token = token
    end

    def user
      user_id = ClaimRefreshToken.decode(@token)[0].deep_symbolize_keys[:user][:id]
      User.find(user_id)
    end

    def call
      attach_tokens(user)
    end
  end
end
