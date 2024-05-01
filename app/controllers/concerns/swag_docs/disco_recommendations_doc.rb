module SwagDocs
  module DiscoRecommendationsDoc
    include Swagger::Blocks
    extend ActiveSupport::Concern
    included do
      swagger_path '/disco_recommendations/queue_recommmendations_for_user' do
        operation :post do
          security do
            key :jwt, []
          end
          key :operationId, 'TriggerRatesWorkers'
          key :description, 'Trigger worker and queue to store updated user items ratings'
          key :tags, ['disco_recs', 'user', 'uploads_ratings', 'predictions', 'queue_to_PR']
          key :produces, ['application/json']
          response 200 do
            key :description, 'shows result and status of worker with ratings and data hash'
            schema do
              key :'$ref', :PredictedRatingsModel
            end
          end
        end
      end
    end
  end

  class PredictedRatingsModel
    include Swagger::Blocks

    swagger_schema :PreductedRatingsModel do
      key :required, [:result, :status]
      property :result do
        key :type, :array
      end
      property :status do
        key :type, :array
      end
      key :required, [:status, :result]
      property :status do
        key :type, :string
      end
      property :result do
        key :type, :json
      end
    end
  end
end
