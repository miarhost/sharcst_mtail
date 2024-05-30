require 'rails_helper'
require 'disco'
require 'sidekiq/testing'

describe 'DiscoRecommendations', type: :request do
  describe 'Token authorization' do
    context 'unauthorized' do
      include_examples 'v1:unauthorized_request', :post, '/api/v1/disco_recommendations/queue_recommendations_for_user', params: {}
    end
  end

  let!(:uploads) { create_list(:upload, 5, user_id: user.id, downloads_count: 7) }
  let!(:subscription) { create(:subscription)}
  let!(:result) { DiscoServices::UserRecommender.call(user) }

  describe 'POST /api/v1/disco_recommendations/queue_recommendations_for_user' do
    include_context 'v1:authorized_request'
    context 'returns succesful responce result of triggered jobs' do

      before { Sidekiq::Testing.inline! }
      before { user.subscription_ids.push(subscription.id)}

      after { Sidekiq::Testing.fake! }

      it 'returns json with result fields' do
        post '/api/v1/disco_recommendations/queue_recommendations_for_user',
          headers: { Authorization: "Bearer: #{authenticate}"}
         expect(response).to have_http_status(:success)
        expect(response.body).to include_json([result])
      end
    end
  end
end
