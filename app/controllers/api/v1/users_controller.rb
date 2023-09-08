module Api
  module V1
    class UsersController < ApplicationController
      def login
        result = Users::Authentication.call(login_params[:email], login_params[:password])
        result.nil? ? not_authorized_message : (render json: { 'authorization': output })
      end

      private

      def login_params
        params.permit(:email, :password)
      end
    end
  end
end
