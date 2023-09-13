require 'rails_helper'
describe Api::V1::UsersController,  type: :controller do
  let!(:user) { create(:user) }
  describe 'POST login' do
    context 'successful access token authentication with valid credentials' do
      it 'returns authorization resppnse for a valid user' do
        post :login, params: { email: user.email, password: user.password }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)).to include("authorization")
      end
    end

    context 'access token authentication declined with invalid credentials' do
      it 'returns not authorized for not valid user' do
        post :login, params: { email: user.email, password: '111111'}
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include_json(
          {
            "status": "unauthorized",
            "message": "User is not authorized"
          }
        )
      end
    end
  end
end
