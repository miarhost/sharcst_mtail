require 'rails_helper'
describe 'Subscriptions', type: :request do

  let!(:authenticate) { Users::Authentication.call(user.email, user.password) }
  let!(:subscription) { create(:subscription) }

  describe 'Token authorization' do
    context 'unauthorized' do
      include_examples 'v1:unauthorized_request', :post, '/api/v1/subscriptions', params: { subscription: { title: 'Created Subscription'} }
    end
  end

  describe 'POST /v1/api/subscriptions' do
    include_context 'v1:authorized_request'
    context 'successfully creates a record' do
      it 'creates new subscription record' do
        post '/api/v1/subscriptions',
            params: { subscription: { title: 'Created Subscription'} },
            headers: { Authorization: "Bearer #{authenticate}"}

        expect(response).to have_http_status(:created)
        expect(response.body).to include_json(
          { 'title': 'Created Subscription' }
        )
      end
    end

    context 'fails to create a record due to validation' do
      it 'returns validation error message' do
        post '/api/v1/subscriptions',
        params: { subscription: { title: '' } },
        headers: { Authorization: "Bearer #{authenticate}"}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include_json(
          {
            "status": "unprocessable_entity",
            "message": "Title can't be blank"
          }
        )
      end
    end
  end
end
