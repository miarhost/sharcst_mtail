require 'rest-client'
class Webhooks::TeamsSlackMessenger
  class << self
    def call(payload)
      RestClient.post(url, JSON.generate({"Today's links"=> payload }), { content_type: :json, accept: :json})
    end

    def url
      ENV['TEAMS_SLACK_URL']
    end
  end
end
