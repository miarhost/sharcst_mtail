require 'bunny'
module BasicSubscriber
  def self.direct_exchange(exchange_name, queue_name)
    connection = Bunny.new
    connection.start
    channel = connection.create_channel

    queue = channel.queue(queue_name, durable: true)

    queue.bind(exchange_name)
    result = []
    queue.subscribe(block: false) { |_delivery_info, _properties, message|  result << message }

    connection.close
    connection = nil
    channel = nil
    result[0]
  end
end
