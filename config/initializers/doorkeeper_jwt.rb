Doorkeeper::JWT.configure do

  token_payload do |opts|
    user = User.find(opts[:resource_owner_id])

    {
      iss: 'sharct_mtail',
      iat: Time.current.utc.to_i,
      aud: opts[:application][:uid],


      jti: SecureRandom.uuid,
      sub: user.id,

      user: {
        id: user.id,
        email: user.email
      }
    }
  end

  use_application_secret false

  secret_key ENV['JWT_HMAC']

  encryption_method ENV['JWT_ALG']
end
