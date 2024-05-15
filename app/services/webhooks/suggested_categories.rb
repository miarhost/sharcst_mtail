require 'rest-client'
module Webhooks
  class SuggestedCategories < ApplicationService

    def initialize(user_id)
      @user_id = user_id
    end

    def url
      ENV['OLLAMA_HOST']
    end

    def call
      RestClient.post(url, data, { content_type: :json, accept: :json } )
    end

    def data
      {"model": "mistral", "prompt: #{topics}"}
    end

    def topics
      Topic.find_by_sql("select distinct topics.title
                         from topics, uploads, users
                         where topics.id = uploads.topic_id and uploads.user_id = #{@user_id}")
           .pluck(:title).join(',')
    end
  end
end
