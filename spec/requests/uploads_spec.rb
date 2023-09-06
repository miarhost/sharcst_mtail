require 'rails_helper'
require 'disco'
require 'sidekiq/testing'
describe 'Uploads', type: :request do
  describe 'GET /api/v1/uploads/:id/load_prediction_for_infos' do
    let!(:upload) { create(:upload) }
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
end
