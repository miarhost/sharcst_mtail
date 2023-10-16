class PredictionsDeliverQueue
  def initialize(records, predictions)
    @records = records
    @predictions = predictions
  end

  def queue_name
    'predictions'
  end

  def publish
    BasicPublisher.queue(queue_name).publish(data_hash.to_json)
  end

  def data_hash
    Hash[@records.pluck(:name).zip(@predictions)]
  end
end
