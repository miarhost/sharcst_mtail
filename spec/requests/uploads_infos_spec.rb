require 'rails_helper'
require 'sidekiq/testing'

describe 'UploadsInfos', type: :request do

  describe 'Token authorization' do
    context 'unautnorized' do
      include_examples 'v1:unauthorized_request', :post, '/api/v1/uploads_infos/1/generate_report', params: { id: 1 }
      include_examples 'v1:unauthorized_request', :patch, '/api/v1/uploads_infos/1/update_streaming_infos', params: { id: 1 }
      include_examples 'v1:unauthorized_request', :patch, '/api/v1/uploads_infos/1', params: { uploads_info: { description: 'Updated description' } }
      include_examples 'v1:unauthorized_request', :delete, '/api/v1/uploads_infos/remove_report', params: { attachment_id: 1 }
    end
  end

  let!(:user) { create(:user) }
  let!(:upload) { create(:upload) }
  let!(:uploads_infos) { create_list(:uploads_info, 3, upload_id: upload.id, user_id: user.id) }
  let!(:uploads_info) { create(:uploads_info, upload_id: upload.id, user_id: user.id) }

  describe 'GET /api/v1/uploads_infos' do
    it 'shows filtered records ordered list with additional reporting attributes' do
      get '/api/v1/uploads_infos', params: { user_id: user.id, log_tag: uploads_infos[0].log_tag }
      expect(response).to have_http_status(200)
      expect(response.body).to include_json(
        [
          {
            "user_id": uploads_infos[0].user_id,
            "upload_id": uploads_infos[0].upload_id,
            "log_tag": uploads_infos[0].log_tag,
            "name": uploads_infos[0].name,
            "media_type": uploads_infos[0].media_type,
            "rating": uploads_infos[0].rating,
            "provider": uploads_infos[0].provider,
            "duration": uploads_infos[0].duration.to_s,
            "description": uploads_infos[0].description,
            "static_info_block": {
              "streaming_statistics": {
                "duration": uploads_infos[0].duration.to_s,
                "marking": uploads_infos[0].name,
                "other": uploads_infos[0].description,
                "send_to": user.email
              }
            }
          }
        ]
      )
    end
  end

  describe 'POST /api/v1/uploads_infos/:id/generate_report' do
    include_context 'v1:authorized_request'

    context 'generation of csv report and instant upload is successful' do
      it 'returns created attachment record' do
        post "/api/v1/uploads_infos/#{uploads_info.id}/generate_report", params: { id: uploads_info.id },
        headers: { Authorization: "Bearer #{authenticate}" }

        expect(response).to have_http_status(200)
        expect(response.body).to include_json(
          {
            "id": uploads_info.uploads_info_attacments.last.id,
            "uploads_info_id": uploads_info.id
          }
        )
      end
    end

    context 'generation of csv report and instant upload has errors' do
      it 'returns json with error message' do
        post '/api/v1/uploads_infos/0/generate_report', params: { id: 0 },
        headers: { Authorization: "Bearer #{authenticate}" }

        expect(response).to have_http_status(404)
        expect(response.body).to include_json(
          {
            "status": 'not_found',
            "message": 'Record not found'
          }
        )
      end
    end
  end

  describe 'PATCH /api/v1/uploads_infos/:id/update_streaming_infos' do
    include_context 'v1:authorized_request'
    let!(:webhook) { create(:webhook, upload_id: upload.id, user_id: user.id) }

    before { Sidekiq::Testing.inline! }

    after { Sidekiq::Testing.fake! }

    context 'update of streaming_infos field is successful' do
      it 'returns uploads info record with updated streaming_infos field' do
        patch "/api/v1/uploads_infos/#{uploads_info.id}/update_streaming_infos", params: { id: uploads_info.id },
        headers: { Authorization: "Bearer #{authenticate}" }

        uploads_info.reload
        expect(response).to have_http_status(200)
        expect(response.body).to include_json(
          {
            "user_id": uploads_info.user_id,
            "upload_id": uploads_info.upload_id,
            "log_tag": uploads_info.log_tag,
            "name": uploads_info.name,
            "streaming_infos": {
              "logging_url": webhook.url
            },
            "media_type": uploads_info.media_type,
            "rating": uploads_info.rating,
            "provider": uploads_info.provider,
            "duration": uploads_info.duration.to_s,
            "description": uploads_info.description,
            "static_info_block": {
              "streaming_statistics": {
                "duration": uploads_info.duration.to_s,
                "marking": uploads_info.name,
                "other": uploads_info.description,
                "send_to": user.email
              }
            }
          }
        )
      end
    end
  end

  describe 'PATCH /api/v1/uploads_infos/:id' do
    include_context 'v1:authorized_request'

    context 'successfully updates a record' do
      it 'returns serialized record' do
        patch "/api/v1/uploads_infos/#{uploads_info.id}",
        params: { uploads_info: { description: 'Updated description', rating: 3 } },
        headers: { Authorization: "Bearer #{authenticate}" }

        expect(response).to have_http_status(:success)
        expect(response.body).to include_json(
          {
            "user_id": uploads_info.user_id,
            "upload_id": uploads_info.upload_id,
            "log_tag": uploads_info.log_tag,
            "name": uploads_info.name,
            "streaming_infos": nil,
            "media_type": uploads_info.media_type,
            "rating": 3,
            "provider": uploads_info.provider,
            "duration": uploads_info.duration.to_s,
            "description": 'Updated description',
            "static_info_block": {
              "streaming_statistics": {
                "duration": uploads_info.duration.to_s,
                "marking": uploads_info.name,
                "other": "Updated description",
                "send_to": user.email
              }
            }
          }
        )
      end
    end

    context 'fails to update a record due to validations' do
      it 'returns serialized error message' do
        patch "/api/v1/uploads_infos/#{uploads_info.id}",
        params: { uploads_info: { name: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.
          Vestibulum commodo porttitor dolor, En porta est bibendum in.' } },
          headers: { Authorization: "Bearer #{authenticate}" }

          expect(response).to have_http_status(422)
          expect(response.body).to include_json(
            {
            'status': 'unprocessable_entity',
            'message': "Name is too long (maximum is 100 characters)"
            }
          )
      end
    end
  end

  describe 'DELETE /api/v1/uploads_infos/remove_report' do
    let!(:report) { create :uploads_info_attacment, uploads_info_id: uploads_info.id }
    include_context 'v1:authorized_request'

    it 'removes report from the bucket and deletes its record' do
      delete "/api/v1/uploads_infos/remove_report", params: { attachment_id: report.id },
      headers: { Authorization: "Bearer #{authenticate}" }

      expect(response).to have_http_status(204)
      expect { report.reload }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end
