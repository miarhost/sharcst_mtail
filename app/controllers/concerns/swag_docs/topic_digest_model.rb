module SwagDocs
  class TopicDigestModel
    include Swagger::Blocks

    swagger_schema :TopicDigestModel do
      key :requred, [:id, :topic_id, :list_of_5, :full_list, :created_at, :updated_at]
      property :id do
        key :type, :integer
        key :format, :int64
      end
      property :topic_id do
        key :type, :integer
        key :format, :int64
      end
      property :list_of_5 do
        key :type, :string
      end
      property :full_list do
        key :type, :string
      end
      property :created_at do
        key :type, :string
        key :format, :datetime
      end
      property :updated_at do
        key :type, :string
        key :format, :datetime
      end
    end
  end
end
