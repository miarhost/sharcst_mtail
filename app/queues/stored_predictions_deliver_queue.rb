class StoredPredictionsDeliverQueue

  def initialize(data)
    @data = data
  end

  def queue_name
    'subscriptions_for_user'
  end

  def publish
    BasicPublisher.queue(queue_name).publish(@data)
  end
end
