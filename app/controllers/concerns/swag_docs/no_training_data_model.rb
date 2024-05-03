class NoTrainingDataModel
include Swagger::Blocks

  swagger_schema :NoTrainingDataModel do
    key :required, [:message, :status]
    property :message do
      key :type, :string
    end
    property :status do
      key :type, :integer
      key :format, :int32
    end
  end
end
