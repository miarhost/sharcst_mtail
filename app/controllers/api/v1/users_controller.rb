module Api
  module V1
    class UsersController < ApplicationController
      include SwagDocs::UsersDoc
      before_action :authorize_request, except: %i[login]

      def login
        result = Users::Authentication.call(login_params[:email], login_params[:password])
        result.nil? ? not_authorized_message : (render json: { 'authorization': result })
      end

      def update_membership
        @current_user.update!(team_id: member_params[:team_id])
        render json: @current_user, serializer: MemberSerializer
      end

      def enqueue_parser_topic
        request = Parsers::RecommendedExternalQueue
          .new(@current_user.id, params[:starts], params[:ends])
          .execute
        status = request.key?(:errors) ? 422 : 201
        render json: request[:result], status: status
      end

      def show_parsed_topic
        Parsers::ParsedTopicQueue.execute(@current_user.id)
      end

      def subscriptions_info
        ratings = SubscriptionsQueries.show_subs_ratings_per_user(@current_user.id)
        render json: ratings
      end

      private

      def login_params
        params.permit(:email, :password)
      end

      def member_params
        params.permit(:team_id)
      end
    end
  end
end
