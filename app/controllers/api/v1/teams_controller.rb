module Api
  module V1
    class TeamsController < ApplicationController
      before_action :authorize_request
      before_action :set_team, except: :create

      def create
        @team = Team.create!(team_params)
        render json: @team, serializer: serializer, status: 201
      end

      def update
        @team.update!(team_params)
        render json: @team, serializer: serializer
      end

      def destroy
        @team.destroy!
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
