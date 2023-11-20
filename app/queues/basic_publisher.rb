require 'bunny'
module BasicPublisher

  def channel
    connection.create_channel
  end

  def direct_exchange
    channel.direct("#{exchange_name}", durable: true)
    queue.bind(exchange_name)
  end

  def connection
    Bunny.new.tap(&:start)
  end

  def queue
    channel.queue(queue_name, durable: true)
  end

  def ack_and_close
    puts channel.acknowledge(2, false)

    channel.close
    connection.close
  end
end
