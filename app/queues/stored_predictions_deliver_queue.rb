class StoredPredictionsDeliverQueue
  def initialize(data)
    @data = data
  end

  def exchange_name
    'snickers'
  end

  def queue_name
    'subscriptions_for_user'
  end

  def execute
    Publisher.direct_exchange(exchange_name, queue_name, @data.to_json)
  rescue StandardError => e
    Rails.logger.error(e.message)
  end
end
