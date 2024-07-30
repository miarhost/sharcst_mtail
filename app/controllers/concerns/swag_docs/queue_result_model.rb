module SwagDocs
  class QueueResultModel
    include Swagger::Blocks

    swagger_schema :QueueResultModel do
      key :required, [:result]
      property :result do
        key :type, :object
        key :properties, [:update_time, :jid, :status, :worker, :args]
      end
    end
  end
end
