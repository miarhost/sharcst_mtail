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
          key :tags, ['disco_recs', 'user', 'uploads_ratings', 'predictions', 'external']
          key :produces, ['application/json']
          response 200 do
            key :description, 'shows result and status of worker with ratings and data hash'
            schema do
              key :'$ref', :PredictedRatingsModel
            end
          end
        end
      end

      swagger_path '/disco_recommendations/queue_daily_recommendations_for_items' do
        operation :get do
          security do
            key :jwt, []
          end
          key :operationId, 'DailyRecsScores'
          key :desciption, 'Extracts items recs for a date and saves to redis'
          key :tags, ['daily_recs', 'redis_storage', 'scores', 'user']
          key :produces, ['application/json']
          response 303 do
            key :description, 'No Training Data response'
            schema do
              key :'$ref', :NoTrainingDataModel
            end
          end

          response 200 do
            key :description, 'shows items names with scores generated'
            schema do
              key :'$ref', :ScoresModel
            end
          end
        end
      end
    end
  end

  class PredictedRatingsModel
    include Swagger::Blocks

    swagger_schema :PredictedRatingsModel do
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

  class ScoresModel
    include Swagger::Blocks

    swagger_schema :ScoresModel do
      key :required, [:item, :score]
      property :item do
        key :type, :string
      end
      property :score do
        key :type, :float
      end
    end
  end
end
