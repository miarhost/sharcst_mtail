module Api
  module V1
    class UsersController < ApplicationController
      before_action :authorize_request, except: %i[login]

      def login
        result = Users::Authentication.call(login_params[:email], login_params[:password])
        result.nil? ? not_authorized_message : (render json: { 'authorization': result })
      end

      def update_membership
        @current_user.update!(team_id: member_params[:team_id])
        render json: @current_user, serializer: MemberSerializer
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
