require 'rails_helper'
require 'disco'
describe 'Subscriptions', type: :request do

  let!(:subscription) { create(:subscription, topic_id: topic.id) }
  let!(:topic) { create(:topic, category_id: category.id) }
  let!(:category) { create(:category) }

  describe 'Token authorization' do
    context 'unauthorized' do
      include_examples 'v1:unauthorized_request', :post, '/api/v1/subscriptions', params: { subscription: { title: 'Created Subscription'} }
      include_examples 'v1:unauthorized_request', :patch, '/api/v1/subscriptions/1', params: { subscription: { title: 'Updated Title'} }
      include_examples 'v1:unauthorized_request', :delete, '/api/v1/subscriptions/1', params: { }
      include_examples 'v1:unauthorized_request', :put, '/api/v1/subscriptions/1/update_stats_preferences', params: { }

    end
  end

  describe 'POST /api/v1/subscriptions' do
    include_context 'v1:authorized_request'
    context 'successfully creates a record' do
      it 'creates new subscription record' do
        post '/api/v1/subscriptions',
            params: { subscription: { title: 'Created Subscription', topic_id: topic.id } },
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
            "message": "Title can't be blank and Topic must exist"
          }
        )
      end
    end
  end

  describe 'PATCH /api/v1/subscriptions/:id/' do
    include_context 'v1:authorized_request'
    context 'successfully updates record' do
      it 'updates subscrription and returns updated attributes' do
        patch "/api/v1/subscriptions/#{subscription.id}",
          params: { subscription: { title: 'Updated Title'}},
          headers: { Authorization: "Bearer #{authenticate}"}

        expect(response).to have_http_status(:success)
        expect(response.body).to include_json(
            { 'title': 'Updated Title'}
          )
      end
    end

    context 'fails to update record' do
      it "doesn't update record and returns error message" do
        patch "/api/v1/subscriptions/#{subscription.id}",
        params: { subscription: { title: nil }},
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

  describe 'DELETE /api/v1/subscriptions/:id' do
    include_context 'v1:authorized_request'
    it 'removes record from database' do
      delete "/api/v1/subscriptions/#{subscription.id}",
      headers: { Authorization: "Bearer #{authenticate}"}

      expect(response).to have_http_status(:no_content)
      expect{ subscription.reload }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end

  describe 'POST /api/v1/subscriptions/:id/store_topic_recommendations' do
    include_context 'v1:authorized_request'

    context 'updates recommendations records for subscription' do
      it 'returns successful disco service output' do
        post "/api/v1/subscriptions/#{subscription.id}/store_topic_recommendations",
        headers: { Authorization: "Bearer #{authenticate}"}

        expect(response).to have_http_status(:success)
        allow(DiscoServices::TopicSubscriptionsUpdater).to receive(:call).with(user.id, topic.category.id)
      end
    end

    context 'no updates due to training data inconsistency' do
      it 'returns traning data handler message' do
        post "/api/v1/subscriptions/#{subscription.id}/store_topic_recommendations",
        headers: { Authorization: "Bearer #{authenticate}" }

        expect(response).to have_http_status(303)
        expect(response).to include_json(
          { message: 'No data updated', status: 303 }
        )
      end
    end


  describe 'PUT /api/v1/subscriptions/:id/update_stats_preferences' do
    include_context 'v1:authorized_request'

    context 'has no record given to update stats recommendations' do
      it 'returns handler record not found message' do
        put "/api/v1/subscriptions/#{subscription.id}/update_stats_preferences",
        headers: { Authorization: "Bearer #{authenticate}" }

        expect(response).to have_http_status(404)
        expect(response.body).to include_json(
          {
            "status": "not_found",
            "message": "Record not found"
          }
        )
      end
    end
  end
end
