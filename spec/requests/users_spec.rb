require 'rails_helper'
describe 'Users', type: :request do

  let!(:user) { create(:user) }
  let!(:authenticate) { Users::Authentication.call(user.email, user.password) }
  let!(:team) { create(:team) }

  describe 'Token authorization' do
    context 'unauthorized' do
     include_examples 'v1:unauthorized_request', :patch, '/api/v1/users/update_membership', params: { team_id: 1 }
    end
  end

  describe 'PATCH /api/v1/users/update_membership' do
  include_context 'v1:authorized_request'
    it 'should attach user to a team' do
      patch '/api/v1/users/update_membership', params: { team_id: team.id },
        headers: { Authorization: "Bearer #{authenticate}" }

      expect(response).to have_http_status(:success)
      expect(response.body).to include_json(
        {
          "last_name": user.last_name,
          "email": user.email,
          "team_id": team.id
        }
      )
      expect(user.reload.team_id).to eq(team.id)
    end
  end
end
