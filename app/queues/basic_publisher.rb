require 'bunny'
module BasicPublisher
  def self.direct_exchange(exchange_name, queue_name, message)
      connection = Bunny.new
      connection.start
      channel = connection.create_channel
      queue = channel.queue(queue_name, durable: true)
      ex = channel.direct("#{exchange_name}", durable: true)
      queue.bind(exchange_name)
      ex.publish(message)
      sleep 6

      connection.close
      connection = nil
      channel = nil
  end
end
