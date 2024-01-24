require 'bunny'
module BasicPublisher
  def self.direct_exchange(exchange_name, queue_name, message)
      connection = Bunny.new
      connection.start
      channel = connection.create_channel
      queue = channel.queue(queue_name, durable: true)
      ex = channel.direct("#{exchange_name}", durable: true)
      queue.bind(exchange_name)
      ex.publish(message, routing_key: queue_name, content_type: 'application/json')

      connection.close
      connection = nil
      channel = nil
  end
end
