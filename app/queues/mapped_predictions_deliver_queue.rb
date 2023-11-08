class MappedPredictionsDeliverQueue
  include BasicPublisher
  def initialize(records, values)
    @records = records
    @values = values
  end

  def queue_name
    'predictions'
  end

  def exchange_name
    'sneakers'
  end

  def data_hash
    Hash[@records.pluck(:name).zip(@values)]
  end


  def execute
    publish('sneakers', data_hash)
  end
end
