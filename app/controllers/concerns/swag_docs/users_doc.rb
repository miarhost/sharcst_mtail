module SwagDocs
  module UsersDoc
    include Swagger::Blocks
    extend ActiveSupport::Concern
    included do
      swagger_path 'users/enqueue_topic' do
        operation :post do
          security do
            key :jwt, []
          end
          key :operationId, 'RequestParserDiscoTopics'
          key :description, 'trigger publisher queue with request to parser at process_ratings (sneakers) for external links by recommended topics'
          key :tags, ['external', 'amqp', 'user', 'topics', 'disco_recs']
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
          response 202 do
            key :description, 'response shows payload sent by queue to consumer. List of main and additional topics picked with collaborative filter'
            schema do
              key :'$ref', :RecTopicsPayloadModel
            end
          end
          response 422 do
            key :description, 'date parameters for query are absent'
            schema do
              key :'$ref', :ErrorResponseModel
            end
          end
        end
      end


      swagger_path 'users/enqueue_related_topics' do
        operation :post do
          security do
            key :jwt, []
          end
          key :operationId, 'RequestParserOllamaTopics'
          key :description, 'trigger publisher queue with request to parser at process_ratings (sneakers) for external links by proposed topics'
          key :tags, ['external', 'amqp', 'user', 'topics', 'ollama']
          key :produces, ['application/json']
          response 200 do
            key :description, 'response shows payload sent by queue to consumer. List of topics proposed by language model'
            schema do
              key :'$ref', :MistralTopicsModel
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

  class MistralTopicsModel
    include Swagger::Blocks

    swagger_schema :MistralTopicsModel do
      key :required, [:result, :message]
      property :result do
        key :type, :array
      end
      property :message do
        key :type, :string
      end
    end
  end
end
