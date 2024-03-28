module Users
  class Authentication < ApplicationService
    include IssueTokens

    def initialize(email, password)
      @email = email
      @password = password
    end

    def user
      User.find_by(email: @email)
    end

    def call
      attach_tokens(user) if user&.authenticate(@password)
    end
  end
end
