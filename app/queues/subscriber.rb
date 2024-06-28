require 'bunny'
module Subscriber
  def self.direct_exchange(exchange_name, queue_name)
    connection = Bunny.new
    connection.start
    channel = connection.create_channel
    queue = channel.queue(queue_name, durable: true)
    result = []
    queue.bind(exchange_name).subscribe(manual_ack: true) do  |delivery_info, properties, payload|
       result << payload
       Rails.logger.info("Received #{[payload]} from #{delivery_info[:routing_key]}")
    end
    connection.close
    connection = nil
    channel = nil
    result[0]
  end
end
