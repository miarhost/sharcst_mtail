require 'bunny'
module BasicPublisher

  def publish(exchange_name, message)
    producer = channel.direct("#{exchange_name}", durable: true)
    producer.publish(message.to_json)
    queue.bind(exchange_name)
    connection.close
  end

  def channel
    connection.create_channel
  end

  def connection
    Bunny.new.tap(&:start)
  end

  def queue
    channel.queue(queue_name, durable: true)
  end

end
