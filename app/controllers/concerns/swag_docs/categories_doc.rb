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
    end
  end
end
