require 'rails_helper'
require 'disco'
require 'sidekiq/testing'

describe 'Uploads', type: :request do
  describe 'Token authorization' do
    context 'unautnorized' do
      include_examples 'v1:unauthorized_request', :post, '/api/v1/uploads/1/upload_file', params: { id: 1, file: 'example_file.png' }
    end
  end

  let!(:upload) { create(:upload) }
  describe 'GET /api/v1/uploads/:id/load_prediction_for_infos' do
    let!(:uploads_infos) { create_list(:uploads_info, 3, upload_id: upload.id) }

    before { Sidekiq::Testing.inline! }

    after { Sidekiq::Testing.fake! }

    it 'performs job up to complete and returns result' do
      get "/api/v1/uploads/#{upload.id}/load_prediction_for_infos", params: { id: upload.id }

      sleep 6
      result = DiscoServices::UploadsRecommender.call(upload.id)

      expect(response).to have_http_status(200)
      expect(response.body).to include_json({ 'predicted rating': result.to_s })
    end
  end

  describe 'POST /api/v1/uploads/:id/upload_file' do
    include_context 'v1:authorized_request'
    it 'successfully uploads a file' do
      post "/api/v1/uploads/#{upload.id}/upload_file", params: { id: upload.id, file: fixture_file_upload('example_file.png') }
      expect(response.status).to eq(200)
      expect(response.body).to eq({ filename: 'example_file.png', upload_id: upload.id }.to_json)
    end
  end
end
