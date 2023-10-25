class MappedPredictionsDeliverQueue
  def initialize(records, predictions)
    @records = records
    @predictions = predictions
  end

  def queue_name
    'predictions'
  end

  def publish
    BasicPublisher.queue(queue_name).publish('snickers', data_hash)
  end

  def data_hash
    Hash[@records.pluck(:name).zip(@predictions)]
  end
end
