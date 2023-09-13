require 'rails_helper'
require 'sidekiq/testing'

describe Api::V1::UploadsController, type: :controller do
  let!(:upload) { FactoryBot.create(:upload) }

  describe '#upload_file' do

    before { Sidekiq::Testing.inline! }

    after { Sidekiq::Testing.fake! }

    context 'file upload is successful' do

      it 'uploads the file attachment and updates upload attachment successfully' do
        post :upload_file, params: { id: upload.id, file: fixture_file_upload('example_file.png') }
        expect(response.status).to eq(200)
        expect(response.body).to eq({ filename: 'example_file.png', upload_id: upload.id }.to_json)
      end
    end

    context 'when the upload is not successful' do
      it 'renders error message when file is empty' do
        post :upload_file, params: { id: upload.id, file: nil }
        expect(response.status).to eq(406)
        expect(response.body).to include({ "status": 'not_acceptable', "message": 'Please add a file' }.to_json)
      end

      it 'renders error message when file is not valid' do
        post :upload_file, params: { id: upload.id, file: fixture_file_upload('text_example.txt') }
        expect(response.status).to eq(422)
        expect(response.body).to include({ "status": 'unprocessable_entity', "message": 'File is not a valid file format' }.to_json)
      end
    end
  end
end
