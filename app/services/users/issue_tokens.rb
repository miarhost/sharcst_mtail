module Users
  module IssueTokens
    def attach_tokens(user)
      jwt_token = Jwt::JwtAuth.new(user).generate_token
      refresh_token = Jwt::GenerateRefreshToken.call(user)

      RedisCache::SaveRt.call(jwt_token, refresh_token, user.id)
      { jwt_token: jwt_token, refresh_token: refresh_token }
    end
  end
end
