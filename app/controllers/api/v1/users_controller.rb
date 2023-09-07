module Api
  module V1
    class UsersController < ApplicationController
      def login
        Users::Authentication.call(login_params[:email], login_params[:password])
      end

      private

      def login_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
