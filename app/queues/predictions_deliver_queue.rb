class PredictionsDeliverQueue
  def initialize(records, predictions)
    @records = records
    @predictions = predictions.split(', ')
  end


  def queue_name
    'predictions for a period'
  end

  def publish
    BasicPublisher.queue(queue_name).publish(data_hash.to_json)
  end

  def data_hash
    @data_hash = Hash[@records.zip(@predictions)]
  end
end
