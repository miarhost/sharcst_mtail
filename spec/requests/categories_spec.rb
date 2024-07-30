require 'rails_helper'
require 'sidekiq/testing'
describe 'Categories', type: :request do

  let!(:category) { create(:category)}

  describe 'Token authorization' do
    context 'unauthorized' do
      include_examples 'v1:unauthorized_request', :post, '/api/v1/categories/1/update_recommendations_stats', params: {}
    end
  end

  after { Sidekiq::Testing.fake! }

  describe "POST /api/v1/categories/:id/update_recommendations_stats" do
    include_context 'v1:authorized_request'
    context 'returns processing job status' do
      it 'enqueues stat creating worker' do
        expect do
          post "/api/v1/categories/#{category.id}/update_recommendations_stats",
          headers: { Authorization: "Bearer: #{authenticate}"}

         end.to change(Update::FillRecsStatWorker.jobs, :size).by(1)

        expect(response).to have_http_status(202)
      end
    end
  end
end
