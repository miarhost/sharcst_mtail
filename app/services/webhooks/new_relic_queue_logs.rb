require 'rest-client'
class Webhooks::NewRelicQueueLogs
  class << self
    def url
      ENV['SLACK_LOGS']
    end

    def call
      RestClient.post(url, data, { content_type: :json, accept: :json } )
    end

    def data
       NewRelic::Agent::Messaging.start_amqp_publish_segment(
        library: 'rabbitmq',
        destination_name: 'snickers',
        headers: nil,
        routing_key: 'parsed',
        reply_to: nil,
        correlation_id: nil,
        exchange_type: 'direct'
       ).to_json
    end
  end
end
