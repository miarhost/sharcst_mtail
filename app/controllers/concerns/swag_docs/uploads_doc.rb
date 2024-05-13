module SwagDocs
  module UploadsDoc
    include Swagger::Blocks
    extend ActiveSupport::Concern
    included do
      swagger_path '/uploads/:id/load_prediction_for_infos' do
        operation :get do
          security do
            key :jwt, []
          end
          key :operationId, 'infosPredictionRating'
          key :desctiption, 'computes predicted rating based on infos'
          key :tags, ['disco_recs', 'predictions', 'upload', 'worker']
          key :produces, ['application/json']

          response 200 do
            key :description, 'shows result of worker triggering recommender with prediction result'
            schema do
              key :'$ref', :PredictionInfosModel
            end
          end

          response 404 do
            key :description, 'handler response for record not found'
            schema do
              key :'$ref', :RecordNotFoundModel
            end
          end
        end
      end
    end
  end

  class PredictionInfosModel
    include Swagger::Blocks

    swagger_schema :PredictionInfosModel do
      key :required, [:predicted_rating]
      property :predicted_rating do
        key :type, :float
      end
    end
  end
end
