class PredictionsDeliverQueue
  def initialize(records, predictions)
    @records = records
    @predictions = predictions
  end


  def queue_name
    'predictions for a period'
  end

  def publish(records, predictions)
    BasicPublisher.queue(queue_name).publish(data_hash.to_json)
  end

  def data_hash
    @data_hash = Hash[records.zip(predictions)]
  end
end
