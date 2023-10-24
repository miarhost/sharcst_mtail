require 'bunny'
class BasicPublisher
  class << self
    def publish(exchange, message = {})
      producer = channel.fanout("#{exchange}")
      producer.publish(message.to_json)
      connection.close
    end

    def channel
      connection.create_channel
    end

    def connection
      Bunny.new.tap(&:start)
    end

    def queue(name)
      channel.queue(name)
    end
  end
end
