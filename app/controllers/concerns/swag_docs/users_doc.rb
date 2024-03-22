module SwagDocs::UsersDoc
  include Swagger::Blocks
  extend ActiveSupport::Concern
  included do
    swagger_path 'users/enqueue_parser_topic' do
      operation :post do
        security do
          key :jwt, []
        end
        key :operationId, 'gueueRequestParserTopics'
        key :description, 'trigger publisher queue with request to parser at process_ratings (sneakers) for external links by related topics'
        key :tags, ['external', 'amqp', 'user']
        key :produces, ['application/json']
        parameter do
          key :name, :starts
          key :in, :query
          key :type, :string
          key :required, :true
        end
        parameter do
          key :name, :ends
          key :in, :query
          key :type, :string
          key :required, :true
        end
        response 201 do
          key :description, 'response shows payload sent by queue to consumer'
          schema do
            key :'$ref', :RecTopicsPayloadModel
          end
        end
      end
    end
  end
end

class RecTopicsPayloadModel
  include Swagger::Blocks

  swagger_schema :RecTopicsPayloadModel do
    key :required, [:rate, :topics, :user, :subtopics]
    property :rate do
      key :type, :integer
      key :format, :int32
    end
    property :topics do
      key :type, :array
    end
    property :user do
      key :type, :integer
      key :format, :int32
    end
    property :subtopics do
      key :type, :string
    end
  end
end
