require 'bunny'
module Subscriber
  def self.direct_exchange(exchange_name, queue_name)
    connection = Bunny.new
    connection.start
    channel = connection.create_channel

    queue = channel.queue(queue_name, durable: true)
    result = []
    consumer = Bunny::Consumer.new(channel, queue, true)

    consumer.on_delivery do |delivery_info, metadata, payload|
      result << payload
      Rails.logger.info(delivery_info)
    end
    connection.close
    connection = nil
    channel = nil
    result[0]
  end
end
