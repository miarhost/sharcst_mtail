require 'bunny'
class BasicPublisher
  class << self
    def publish(exchange, message = {})
      entity = channel.fanout("crawler.#{exchange}")
      entity.publish(message.to_json)
    end

    def channel
      @channel ||= connection.create_channel
    end

    def connection
      @connection = Bunny.new.tap(&:start)
    end

    def config
      {
        user:  ENV['RABBITMQ_DEFAULT_USER'],
        pass:  ENV['RABBITMQ_DEFAULT_PASS'],
        host:  ENV['RABBITMQ_HOST'],
        port:  ENV['RABBITMQ_PORT'],
        vhost: ENV['RABBITMQ_DEFAULT_VHOST']
      }
    end

    def queue(name)
      channel.queue(name, durable: true)
    end
  end
end
