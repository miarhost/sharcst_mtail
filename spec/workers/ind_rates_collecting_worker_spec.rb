require 'rails_helper'

describe Uploads::IndRatesCollectingWorker, type: :worker do
  let!(:user) { create(:user) }
  let!(:upload) { create(:upload, category: 'tech') }
  let!(:result) { described_class.new.perform(payload) }
  let!(:payload) { {'user_id': user.id, 'upload_id': upload.id, 'rating': 9}.to_json }

  describe "#perform" do
    context 'performs with a successful result' do
      it 'returns success message from job status' do
        expect(Sidekiq::Status.get(result, :status)).to eq('done')
        expect(Sidekiq::Status.get(result, :result)).to eq({"#{Time.now}": "updated"})
      end
    end

    context 'fails with error' do
      let!(:payload) { 3 }
      it 'returns error message from job status' do
        expect(Sidekiq::Status.get(result, :result)).to include('error')
      end
    end
  end
end
