# frozen_string_literal: true

Doorkeeper.configure do

  orm :active_record

  default_scopes :read
  optional_scopes :write

  default_scopes 'user:subscription_info'

  enforce_configured_scopes

  resource_owner_authenticator do
    head :forbidden unless Users::Authorization.call(request.headers)
  end

  api_only
  base_controller 'ActionController::API'

  access_token_generator '::Doorkeeper::JWT'

end

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
