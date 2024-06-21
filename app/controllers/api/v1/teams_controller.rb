module Api
  module V1
    class TeamsController < ApplicationController
      include SwagDocs::TeamsDoc
      before_action :authorize_request
      before_action :set_team, except: :create

      def create
        @team = Team.create!(team_params)
        render json: @team, serializer: , status: 201
      end

      def update
        @team.update!(team_params)
        render json: @team, serializer:
      end

      def destroy
        @team.destroy!
      end

      def store_recommendations_for_team
        unless @team.topic
          no_training_data_response
        else
        render json: DiscoServices::TeamRecommender.call(params[:id]), status: 201
        end
      end

      def queue_parsing_by_topic
        message = ({ url: ExternalResources::EDU, topic: @team&.topic.title }).as_json.with_indifferent_access
        render json: { message: message, result: Parsers::EdTopicParserQueue.execute(message) }
      rescue StandardError
        skip_action
      end

      def show_parsed_by_topic
        result = Parsers::ParsedLinksQueue.execute(@team.id)
        Webhooks::TeamsSlackMessenger.call(result)
        render json: result
      end

      private

      def serializer
        TeamSerializer
      end

      def set_team
        @team = Team.find(params[:id])
      end

      def team_params
        params.require(:team).permit(:tag, :category_id, :topic_id)
      end
    end
  end
end
