require 'rails_helper'
require 'disco'
require 'sidekiq/testing'

describe 'Uploads', type: :request do
  describe 'Token authorization' do
    context 'unautnorized' do
      include_examples 'v1:unauthorized_request', :post, '/api/v1/uploads/1/upload_file', params: { id: 1, file: 'example_file.png' }
      include_examples 'v1:unauthorized_request', :post, '/api/v1/uploads/', params: { 'upload': {'name': 'Test folder' } }
      include_examples 'v1:unauthorized_request', :patch, '/api/v1/uploads/1', params: { 'upload': {'name': 'Updated folder name' } }
      include_examples 'v1:unauthorized_request', :delete, '/api/v1/uploads/1/remove_file', params: { id: 1 }
      include_examples 'v1:unauthorized_request', :get, '/api/v1/uploads/1/load_prediction_for_infos', params: { id: 1 }
      include_examples 'v1:unauthorized_request', :get, '/api/v1/uploads/1/download_file', params: { id: 1 }
    end
  end

  let!(:upload) { create(:upload) }
  let!(:user) { FactoryBot.create(:user) }

  describe 'GET /api/v1/uploads/:id/load_prediction_for_infos' do
    include_context 'v1:authorized_request'
    let!(:uploads_infos) { create_list(:uploads_info, 3, upload_id: upload.id) }

    before { Sidekiq::Testing.inline! }

    after { Sidekiq::Testing.fake! }

    it 'performs job up to complete and returns result' do
      get "/api/v1/uploads/#{upload.id}/load_prediction_for_infos", params: { id: upload.id },
      headers: { Authorization: "Bearer #{authenticate}" }

      result = DiscoServices::UploadsRecommender.call(uploads_infos.pluck(:id))

      expect(response).to have_http_status(200)
      expect(response.body).to include_json({ 'predicted rating': result.to_s })
    end
  end

  describe 'POST /api/v1/uploads/:id/upload_file' do
    include_context 'v1:authorized_request'
    context 'successfully creates an attachment' do
      it 'successfully uploads a file' do
        post "/api/v1/uploads/#{upload.id}/upload_file", params: { id: upload.id, file: fixture_file_upload('example_file.png') },
        headers: { Authorization: "Bearer #{authenticate}" }

        expect(response.status).to eq(200)
        expect(response.body).to eq({ filename: 'example_file.png', upload_id: upload.id }.to_json)
      end
    end

    context 'purges attached file with error statement' do
      it 'when file is empty' do
        post "/api/v1/uploads/#{upload.id}/upload_file", params: { id: upload.id, file: nil },
        headers: { Authorization: "Bearer #{authenticate}" }

        expect(response.status).to eq(406)
        expect(response.body).to include_json(
          {
            'status': 'not_acceptable',
            'message': 'Please add a file'
          }
        )
      end

      it 'when file is unappropriate format' do
        post "/api/v1/uploads/#{upload.id}/upload_file",
        params: { id: upload.id, file: fixture_file_upload('text_example.txt') },
        headers: { Authorization: "Bearer #{authenticate}"}

        expect(response.status).to eq(422)
        expect(response.body).to include_json(
          {
            'status': 'unprocessable_entity',
            'message': 'File is not a valid file format'
          }
        )
      end

      it 'when file is unappropriate size' do
        post "/api/v1/uploads/#{upload.id}/upload_file",
        params: { id: upload.id, file: fixture_file_upload('invalid_size_file_example.jpg') },
        headers: { Authorization: "Bearer #{authenticate}"}

        expect(response.status).to eq(422)
        expect(response.body).to include_json(
          {
            'status': 'unprocessable_entity',
            'message': 'File File size should be greater than 2 KB'
          }
        )
      end
    end
  end

  describe 'POST /api/v1/uploads' do
    include_context 'v1:authorized_request'
    context 'successfully creates an upload' do
      it "returns json with created record's attributes" do
        post '/api/v1/uploads', params: { 'upload': {'name': 'Test folder'} },
        headers: { Authorization: "Bearer #{authenticate}" }

        expect(response).to have_http_status(:created)
        expect(response.body).to include_json(
          {
            'user_id': user.id,
            'name': 'Test folder',
            'upload_attachment': nil
          }
        )
      end
    end

    context 'fails to create a record due to validation' do
      it "doesn't create an upload with a blank name" do
        post '/api/v1/uploads', params: {'upload': { 'name': ''} },
        headers: { Authorization: "Bearer #{authenticate}"}

          expect(response).to have_http_status(422)
          expect(response.body).to include_json(
            {
            'status': 'unprocessable_entity',
            'message': "Name can't be blank"
            }
          )
      end
    end
  end

  describe 'PATCH /api/v1/uploads/:id' do
    include_context 'v1:authorized_request'
    context 'successfully updates record' do
      it 'returns json with updated record attributes' do
        patch "/api/v1/uploads/#{upload.id}", params: { 'upload': {'name': 'Updated folder name'} },
        headers: { Authorization: "Bearer #{authenticate}" }

        expect(response.status).to eq(200)
        expect(response.body).to include_json(
          {
            'user_id': upload.user.id,
            'name': 'Updated folder name',
            'upload_attachment': nil
          }
        )
      end
    end

    context 'fails to update record' do
      it 'returns json with error message' do
        patch "/api/v1/uploads/#{upload.id}", params: { 'upload': { 'name': '' } },
        headers: { Authorization: "Bearer #{authenticate}" }

        expect(response.status).to eq(422)
        expect(response.body).to include_json(
          {
            'status': 'unprocessable_entity',
            'message': "Name can't be blank"
          }
        )
      end
    end
  end

  describe 'DELETE /api/v1/uploads/:id/remove_file' do
    let!(:upload_attachment) { create(:upload_attachment, upload_id: upload.id) }
    include_context 'v1:authorized_request'
    it 'successfully removes file attachment' do
      delete "/api/v1/uploads/#{upload.id}/remove_file", params: { "id": upload.id },
      headers: { Authorization: "Bearer #{authenticate}" }
      expect(response.status).to eq(204)
      expect { upload_attachment.reload }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end

  describe 'GET /api/v1/uploads/:id/download_file' do
    let!(:upload_attachment) { create(:upload_attachment, upload_id: upload.id) }
    include_context 'v1:authorized_request'

    context 'successful download' do
      before { upload_attachment.attach(io: File.open(fixture_file_upload('example_file.png')), filename: 'example_file.png') }
      it 'successfully downloads file from storage in binary format' do
        get "/api/v1/uploads/#{upload.id}/download_file",
        headers: { Authorization: "Bearer #{authenticate}" }

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['file']).to be_an_instance_of(String)
      end
    end

    context 'failed download' do
      it 'returns error message for an absent file' do
        get "/api/v1/uploads/#{upload.id}/download_file",
        headers: { Authorization: "Bearer #{authenticate}" }

        expect(response.status).to eq(404)
        expect(response.body).to include_json(
          "status": "not_found",
          "message": "Record not found"
        )
      end
    end
  end

  describe 'GET /api/v1/uploads/public_downloads_list' do
    let!(:public_upload_downloaded) { create(:upload, status: 'public', downloads_count: 1) }
    let!(:private_upload_downloaded) { create(:upload, status: 'private', downloads_count: 120) }
    let!(:public_upload_not_downloaded) { create(:upload, name: 'Not Downloaded', status: 'public', downloads_count: 0) }
    let!(:public_upload_downloaded_with_removed_attachment) { create(:upload, status: 'public', downloads_count: 33) }
    let!(:upload_attachment) { create(:upload_attachment, upload_id: public_upload_downloaded.id) }
    context 'list inclusions' do
      before { upload_attachment.attach(io: File.open(fixture_file_upload('example_file.png')), filename: 'example_file.png') }
      it 'shows all uploads had been downloaded by users with file links in order by downloads count' do
        get '/api/v1/uploads/public_downloads_list'

        expect(response).to have_http_status(200)
        expect(response.body).to include_json(
          [
            {
              name: public_upload_downloaded_with_removed_attachment.name,
              status: "public",
              downloads_count: 33,
              upload_attachment: nil
            },
            {
              name: public_upload_downloaded.name,
              status: "public",
              downloads_count: 1,
              upload_attachment: {
                filename: 'example_file.png'
              }
            },

          ]
        )
        expect(JSON.parse(response.body)[1]['upload_attachment']['download_link']).to match(/example_file.png/)
      end
    end

    context 'list exclusions' do
      it "doesn't show private uploads with any downloads number or never downloaded" do
        get '/api/v1/uploads/public_downloads_list'

        expect(response).to have_http_status(200)
        expect(response.body).not_to include_json(
          [
            name: 'Not Downloaded',
            status: 'private',
            downloads_count: 0
          ]
        )
      end
    end
  end
end
