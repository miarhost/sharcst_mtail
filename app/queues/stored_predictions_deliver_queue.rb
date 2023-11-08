class StoredPredictionsDeliverQueue
  include BasicPublisher
  def initialize(data)
    @data = data
  end

  def queue_name
    'subscriptions_for_user'
  end

  def execute
    publish('snickers', @data)
  end
end
