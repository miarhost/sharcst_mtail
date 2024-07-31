module SwagDocs
  module CategoriesDoc
    include Swagger::Blocks
    extend ActiveSupport::Concern
    included do
      swagger_path '/categories/{id}/update_recommendations_stats' do
        operation :post do
          security do
            key :jwt, []
          end
          key :operationId, 'FillStatWorker'
          key :description, 'Triggers worker creating CategoryStat with related records stats json fields'
          key :tags, ['recommendations_stats', 'category']
          key :produces, ['application/json']
          response 202 do
            key :description, 'shows worker status values'
            schema do
              key :'$ref', :QueueResultModel
            end
          end
        end
      end

      swagger_path '/categories/{id}/show_recommendations_stats' do
        operation :get do
          key :operationId, 'RecsStatsbyCategory'
          key :description, 'Serialized list of Recs and Cat stats with picked recommendations attributes'
          key :tags, ['recommendations_stats', 'category']
          key :produces, ['application/json']
          response 200 do
            key :description, 'shows uploads_recs, infos_ratings, user_ids, related_topics per item'
            schema do
              key :type, :array
              items do
                key :'$ref', :CatStatWithRecsModel
              end
            end
          end
        end
      end
    end
  end
end
