module SwagDocs
 module SubscriptionsDoc
   include Swagger::Blocks
   extend ActiveSupport::Concern
   included do
    swagger_path '/subscriptions/{id}/store_topic_recommendations' do
      operation :post do
        security do
          key :jwt, []
        end
        parameter do
          key :name, :id
          key :in, :path
          key :required, true
          key :type, :integer
          key :format, :int64
        end
        key :operationId, 'createSubsRecommendations'
        key :description, 'Create topic based recommendations for subscriptions'
        key :tags, ['disco_recs', 'subscriptions']
        key :produces, ['application/json']
        response 200 do
          key :description, 'serialized just created disco recommendations db records'
          schema do
            key :type, :array
            items do
            :'$ref', :DiscoRecommendationModel
            end
          end
        end
        response 303 do
          key :description, 'no training data response'
          schema do
            :'$ref', :ErrorResponseModel
          end
        end
      end
    end
  end

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
        key :type, :float
      end
      property :created_at do
        key :type, :string
        key :format, :datetime
      end
    end
  end
end
