require 'faraday'
module Doorkeeper
  class AuthRequests

    def initialize(jwt_token)
      @jwt_token = jwt_token
    end

    def token_request
      response = Faraday.post("#{ENV['APPLICATION_HOST']}/oauth/token", {
        grant_type: 'authorization_code',
        code: code_request,
        redirect_uri: application.redirect_uri,
        client_id: application.uid,
        client_secret: application.secret }.to_json, {'Content-Type' => 'application/json'})

      result = JSON.parse(response.body)
      result['access_token'] ? result['access_token'] : result['error_description']
    end

    def code_request
      response = Faraday.post("#{ENV['APPLICATION_HOST']}/localhost:3000/oauth/authorize",
        { response_type: 'code',
          redirect_uri: application.redirect_uri,
          client_id: application.uid,
          client_secret: application.secret
        }.to_json, { 'Content-Type' => 'application/json'  })

      result = JSON.parse(response.body)
      if result['redirect_uri']
        result['redirect_uri'].partition('code=')[2]
      else
        result['error_description']
      end
    end

    private

    def application
      Doorkeeper::Application.last
    end
  end
end
