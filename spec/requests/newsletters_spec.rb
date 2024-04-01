require 'rails_helper'
describe 'Newsletters', type: :request do
  let!(:subscription) { create(:subscription, topic_id: topic.id) }
  let!(:newsletter) { create(:newsletter, subscription_id: subscription.id) }
  let!(:user) { create(:user, subscription_ids: [subscription.id]) }
  let!(:other_users) { create_list(:user, 3, subscription_ids: [subscription.id])}
  let!(:topic) { create(:topic)}

  describe 'Token authorization' do
    context 'unauthorized' do
      include_context 'v1:unauthorized_request', :post, "/api/v1/newsletters/1/sms_users_newsletter", params: { id: 1 }
    end
  end

  describe 'POST /api/v1/newsletters/:id/sms_users_newsletter' do
    include_context 'v1:authorized_request'
    it 'delivers sms on newsletter and gets success response' do
      post "/api/v1/newsletters/#{newsletter.id}/sms_users_newsletter",
      params: { id: newsletter.id },
      headers: { Authorization: "Bearer #{authenticate}"}

      expect(response).to have_http_status(:success)
      expect(response.body).to eq(
        [
          {
          "status": "queued",
          "body": "Sent from your Twilio trial account - New Event"
          }
        ]
      )
    end
  end
end
