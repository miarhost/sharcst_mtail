module SwagDocs
  module TeamsDoc
    include Swagger::Blocks
    extend ActiveSupport::Concern
    included do
      swagger_path '/teams/{id}/store_recommendations_for_team' do
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
            key :required, true
          end
          response 201 do
            key :description, 'response shows result of target topic max rated query'
            schema do
              key :'$ref', :TargetTopicsMaxRatedModel
            end
          end
        end
      end

      swagger_path '/teams' do
        operation :post do
          security do
            key :jwt, []
          end
          key :operationId, 'createTeam'
          key :description, 'create team record'
          key :tags, ['crud', 'team']
          key :produces, ['application/json']
          parameter do
            key :name, :team
            key :in, :body
            key :reguired, true
            schema do
              key :'$ref', :TeamFormModel
            end
          end
          response 201 do
            key :description, 'created team with users, category, topic'
            schema do
              key :'$ref', :TeamSerializerModel
            end
          end
          response 429 do
            key :description, 'record validation errors'
            schema do
              key :'$ref', :ErrorResponseModel
            end
          end
        end
      end
    end

    swagger_path '/teams/{id}' do
      operation :patch do
        security do
          key :jwt, []
        end
        key :operationId, 'updateTeam'
        key :description, 'update team record'
        key :tags, ['crud', 'team']
        key :produces, ['application/json']
        parameter do
          key :name, :team
          key :in, :body
          key :required, true
          schema do
            key :'$ref', :TeamFormModel
          end
        end
        response 200 do
          key :description, 'successfully updated team'
          schema do
            key :'$ref', :TeamSerializerModel
          end
        end
        response 429 do
          key :description, 'record validation errors'
          schema do
            key :'$ref', :ErrorResponseModel
          end
        end
      end
      operation :delete do
        security do
          key :jwt, []
        end
        key :operationId, 'deteleTeam'
        key :description, 'delete team record'
        key :tags, ['crud', 'team']
        key :produces, ['application/json']
        response 204 do
          key :description, 'successfully deleted team'
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
        key :format, :int64
      end
      property :max do
        key :type, :integer
        key :format, :int32
      end
    end
  end

  class TeamFormModel
    include Swagger::Blocks

    swagger_schema :TeamFormModel do
      key :required, [:tag]
      property :tag do
        key :type, :string
      end
      property :category_id do
        key :type, :integer
        key :format, :int64
      end
      property :topic_id do
        key :type, :integer
        key :format, :int64
      end
    end
  end

  class TeamSerializerModel
    include Swagger::Blocks

    swagger_schema :TeamSerializerModel do
      key :required, [:tag, :users, :category, :topic]
      property :tag do
        key :type, :string
      end
      property :users do
        key :type, :array
      end
      property :category do
        key :type, :object
        property :title do
          key :type, :string
        end
      end
      property :topic do
        key :type, :object
        property :title do
          key :type, :string
        end
      end
    end
  end
end
