# frozen_string_literal: true

Doorkeeper.configure do

  orm :active_record

  default_scopes :read
  optional_scopes :write

  default_scopes 'user:subscription_info'

  enforce_configured_scopes

  resource_owner_authenticator do
    Users::Authorization.call(request.headers)
  end

  api_only
  base_controller 'ActionController::API'

  access_token_generator '::Doorkeeper::JWT'

end
