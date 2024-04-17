module SwagDocs
  module TeamsDoc
    include Swagger::Blocks
    extend ActiveSupport::Concern
    included do
      swagger_path 'teams/:id/store_recommendations_for_team' do
        operation :post do
          security do
            key :jwt, []
          end
          key :operationId, 'storeRecsForTeam'
          key :description, 'save computed recs with rates for teamId into db records'
          key :tags, ['disco_recs', 'team']
          key :produces, ['application/json']
          parameter do
            key :name, :id
            key :in, :query
            key :type, :integer
            key :required, :true
          end
          response 201 do
            key :description, 'response shows result of target topic max rated query'
            schema do
              key :'$ref', :TargetTopicsMaxRatedModel
            end
          end
        end
      end
    end
  end

  class TargetTopicsMaxRatedModel
    include Swagger::Blocks

    swagger_schema :TargetTopicsMaxRatedModel do
      key :required, [:id, :max]
      property :id do
        key :type, :integer
        key :format, :int32
      end
      property :max do
        key :type, :integer
        key :format, :int32
      end
    end
  end
end
