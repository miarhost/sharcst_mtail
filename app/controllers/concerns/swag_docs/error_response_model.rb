module SwagDocs
  class ErrorResponseModel
    include Swagger::Blocks

    swagger_schema :ErrorResponseModel do
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
