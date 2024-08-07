module SwagDocs
  module UploadsDoc
    include Swagger::Blocks
    extend ActiveSupport::Concern
    included do
      swagger_path '/uploads/{id}/load_prediction_for_infos' do
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
              key :'$ref', :ErrorResponseModel
            end
          end
        end
      end

      swagger_path 'uploads/{id}/update_recs_by_infos' do
        operation :post do
          security do
            key :jwt, []
          end
          key :operationId, 'createInfosRecs'
          key :description, 'creates infos recommendations and updates stat record'
          key :tags, ['disco_recs', 'stats', 'upload']
          key :produces, ['application/json']

          response 200 do
            key :description, 'list of recommended infos'
            schema do
              key :type, :array
              items do
                key :'$ref', :UploadsInfoModel
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
