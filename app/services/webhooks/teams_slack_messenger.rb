require 'faraday'
class Webhooks::TeamsSlackMessenger
  class << self
    def call(payload)
      Faraday.post(url, JSON.generate({"Today's Links" => payload}), "Content-Type" => "application/json")
    end

    def url
      ENV['TEAMS_SLACK_URL']
    end
  end
end
