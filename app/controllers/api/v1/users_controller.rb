module Api
  module V1
    class UsersController < ApplicationController
      include SwagDocs::UsersDoc
      before_action :authorize_request, except: %i[login refresh_token]

      def login
        result = Users::Authentication.call(login_params[:email], login_params[:password])
        result.nil? ? not_authorized_message : (render json: { 'authorization': result })
      end

      def refresh_token
        token = bearer.split(" ")[1]
        rt_token = RedisCache::FetchRt.call(token)
        result = Users::RefreshToken.call(rt_token)
        render json: result
      end

      def update_membership
        @current_user.update!(team_id: member_params[:team_id])
        render json: @current_user, serializer: MemberSerializer
      end

      def enqueue_parser_topic
        request = Parsers::RecommendedExternalQueue
          .new(@current_user.id, enqueue_params[:starts], enqueue_params[:ends])
          .execute
        status = request.key?(:errors) ? 422 : 201
        render json: request[:result], status: status
      rescue StandardError
        raise QueryParamsEmpty
      end

      def show_parsed_topic
        Parsers::ParsedTopicQueue.execute(@current_user.id)
      end

      def subscriptions_info
        last_links = []
        ratings = SubscriptionsQueries.show_subs_ratings_per_user(@current_user.id)
        @current_user.subscription_ids.each do |sid|
          last_links << SubscriptionsQueries.users_and_extlinks_by_subscription(sid)[:links]
        end
        render json: {'subscriptions_ratings': ratings, links: last_links.flatten }
      end

      private

      def login_params
        params.permit(:email, :password, :refresh_token)
      end

      def member_params
        params.permit(:team_id)
      end

      def enqueue_params
        params.permit(:starts, :ends)
      end
    end
  end
end
