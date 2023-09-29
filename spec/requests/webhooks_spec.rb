require 'rails_helper'
describe 'Webhooks', type: :request do
  let!(:user){ create(:user) }
  let!(:authenticate){ Users::Authentication.call(user.email, user.password) }
  let!(:webhook) { create(:webhook) }
  describe 'Token authorization' do
    context 'unauthorized' do
      include_examples 'v1:unauthorized_request', :post, '/api/v1/webhooks',
      params: { webhook: { url: 'https://example.com/test', secret: 'test' } }

      include_examples 'v1:unauthorized_request', :patch, '/api/v1/webhooks/1',
      params: { webhook: { secret: 'updated secret'} }
    end
  end

  describe 'POST /api/v1/webhooks' do
    include_context 'v1:authorized_request'
    context 'successful record creation' do
      it 'creates a new webhook' do
        post '/api/v1/webhooks',
        params: {
          webhook: { url: 'https://example.com/test',
          secret: 'test' }
        },
        headers: { Authorization: "Bearer #{authenticate}" }

        expect(response.status).to eq(201)
        expect(response.body).to include_json(
          {'webhook':
            {
              'user_id': user.id,
              'secret': 'test',
              'url': 'https://example.com/test'
            }
          }
        )
      end
    end

    context 'fails to create a record due to validations' do
      it 'renders status 422 and error message for a record with invalid url format' do
        post '/api/v1/webhooks',
        params: { webhook: { url: 'example.com',
          secret: 'test' } },
        headers: { Authorization: "Bearer #{authenticate}" }

        expect(response.status).to eq(422)
        expect(response.body).to include_json(
          {
            'status': 'unprocessable_entity',
            'message': 'Url is invalid'
          }
        )
      end

      it 'renders status 422 and error message for a record with absent secret' do
        post '/api/v1/webhooks',
        params: { webhook: { url: 'http://example.com' } },
        headers: { Authorization: "Bearer #{authenticate}" }

        expect(response.status).to eq(422)
        expect(response.body).to include_json(
          {
            'status': 'unprocessable_entity',
            'message': "Secret can't be blank"
          }
        )
      end
    end
  end

  describe 'PATCH /api/v1/webhooks/:id' do
    include_context 'v1:authorized_request'
    context 'successfully updates a record' do
      it 'returns updated record' do
        patch "/api/v1/webhooks/#{webhook.id}",
        params: { webhook: { secret: 'updated secret'} },
        headers: { Authorization: "#{authenticate}" }

        expect(response.status).to eq(200)
        expect(response.body).to include_json(
            {
              'user_id': webhook.user.id,
              'secret': 'updated secret'
            }
        )
      end
    end

    context 'fails to update a record' do
      it 'renders status 422 and error message for a record with invalid url format' do
        patch "/api/v1/webhooks/#{webhook.id}",
        params: { webhook: { url: 'example.com',
          secret: 'test' } },
        headers: { Authorization: "Bearer #{authenticate}" }

        expect(response.status).to eq(422)
        expect(response.body).to include_json(
          {
            'status': 'unprocessable_entity',
            'message': 'Url is invalid'
          }
        )
      end

      it 'renders status 422 and error message for a record with absent secret' do
        patch "/api/v1/webhooks/#{webhook.id}",
        params: { webhook: { url: 'http://example.com', secret: nil } },
        headers: { Authorization: "Bearer #{authenticate}" }

        expect(response.status).to eq(422)
        expect(response.body).to include_json(
          {
            'status': 'unprocessable_entity',
            'message': "Secret can't be blank"
          }
        )
      end
    end
  end

  describe 'POST /api/v1/webhooks/:id/slack_notification_for_report' do
    let!(:webhook) { create(:webhook, url: ENV['SLACK_URL']) }
    let!(:upload_attachment) { create(:upload_attachment) }
    before do
    end
    it 'triggers notifier service and returns succesful result' do
      post "/api/v1/webhooks/#{webhook.id}/slack_notification_for_report",
      params: { id: webhook.id, resource_id: upload_attachment.id },
      headers: { Authorization: "Bearer #{authenticate}" }

      expect(response.status).to eq(200)
      expect(response.body).to include_json(
        {
          "status": "done",
          "message": "ok"
        }
      )
    end
  end
end
