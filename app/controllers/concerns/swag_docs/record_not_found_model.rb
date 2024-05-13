module SwagDocs
  class RecordNotFoundModel
    include Swagger::Blocks

    swagger_schema :RecordNotFoundModel do
      key :required, [:status, :message]
      property :status do
        key :type, :string
      end
      property :message do
        key :type, :string
      end
    end
  end
end
