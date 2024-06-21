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
              key :'$ref', :DiscoRecommendationModel
              end
            end
          end
          response 303 do
            key :description, 'no training data response'
            schema do
              key :'$ref', :ErrorResponseModel
            end
          end
        end
      end
    end
  end
end
