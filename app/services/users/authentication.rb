module Users
  class Authentication < ApplicationService
    include IssueTokens

    def initialize(email, password, ip)
      @email = email
      @password = password
      @ip = ip
    end

    def user
      User.find_by(email: @email)
    end

    def call
      if user&.authenticate(@password)
        user.update!(current_sign_in_ip: @ip, sign_in_count: user.sign_in_count + 1)
        attach_tokens(user)
      end
    end
  end
end
