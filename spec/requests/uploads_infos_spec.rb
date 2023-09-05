require 'rails_helper'
require 'sidekiq/testing'

describe 'UploadsInfos', type: :request do
  let(:user) { create(:user) }
  let(:upload) { create(:upload) }
  let!(:uploads_infos) { create_list(:uploads_info, 3, upload_id: upload.id, user_id: user.id) }
  let!(:uploads_info) { create(:uploads_info, upload_id: upload.id, user_id: user.id) }

  describe 'GET /api/v1/uploads_infos' do
    it 'shows filtered records ordered list with additional reporting attributes' do
      get '/api/v1/uploads_infos', params: { user_id: user.id, protocol: uploads_infos[0].protocol }
      expect(response).to have_http_status(200)
      expect(response.body).to include_json(
        [
          {
            "user_id": uploads_infos[0].user_id,
            "upload_id": uploads_infos[0].upload_id,
            "protocol": uploads_infos[0].protocol,
            "name": uploads_infos[0].name,
            "media_type": uploads_infos[0].media_type,
            "number_of_seeds": uploads_infos[0].number_of_seeds,
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
    let!(:uploads_info) { create(:uploads_info, upload_id: upload.id, user_id: user.id) }
    context 'generation of csv report and instant upload is successful' do
      it 'returns created attachment record' do
        post "/api/v1/uploads_infos/#{uploads_info.id}/generate_report", params: { id: uploads_info.id }
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
        post '/uploads_infos/0/generate_report', params: { id: 0 }
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
    let!(:webhook) { create(:webhook, upload_id: upload.id, user_id: user.id) }

    before { Sidekiq::Testing.inline! }

    after { Sidekiq::Testing.fake! }

    context 'update of streaming_infos field is successful' do
      it 'returns uploads info record with updated streaming_infos field' do
        patch "/api/v1/uploads_infos/#{uploads_info.id}/update_streaming_infos", params: { id: uploads_info.id }
        uploads_info.reload
        expect(response).to have_http_status(200)
        expect(response.body).to include_json(
          {
            "user_id": uploads_info.user_id,
            "upload_id": uploads_info.upload_id,
            "protocol": uploads_info.protocol,
            "name": uploads_info.name,
            "streaming_infos": {
              "logging_url": webhook.url
            },
            "media_type": uploads_info.media_type,
            "number_of_seeds": uploads_info.number_of_seeds,
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
end
