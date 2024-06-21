module SwagDocs
  class DiscoRecommendationModel
    include Swagger::Blocks

    swagger_schema :DiscoRecommendationModel do
      key :required, [:subject_type, :subject_id, :item_type, :item_id, :score, :created_at]
      property :subject_type do
        key :type, :string
      end
      property :subject_id do
        key :type, :integer
        key :format, :int64
      end
      property :item_type do
        key :type, :string
      end
      property :item_id do
        key :type, :integer
        key :format, :int64
      end
      property :score do
        key :type, :number
        key :format, :float
      end
      property :created_at do
        key :type, :string
        key :format, :datetime
      end
    end
  end
end
