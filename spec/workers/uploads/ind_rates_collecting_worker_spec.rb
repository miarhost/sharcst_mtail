require 'rails_helper'

describe Uploads::IndRatesCollectingWorker, type: :worker do
  let!(:user) { create(:user) }
  let!(:upload) { create(:upload, category: 'tech') }
  let!(:payload) { {'user_id': user.id, 'upload_id': upload.id, 'rating': 9}.to_json }
  let(:worker_async) { described_class.perform_async(payload) }

   Sidekiq::Testing.fake!

  describe "#perform" do
    context 'performs with a successful result' do
      it 'enqueues collecting job' do
        expect { worker_async }.to change(described_class.jobs, :size).by(1)
      end

      it 'returns successful Status result' do
        worker_immediate = Sidekiq::Testing.inline! { worker_async }
        expect(Sidekiq::Status.get(worker_immediate, :result))
          .to eq("{:rate=>#{JSON.parse(payload)['rating']}, :user=>#{user.id}}")
      end
    end

    context 'fails with errors' do
      let!(:payload) {}
      it 'returns error Status result' do
        worker_immediate = Sidekiq::Testing.inline! { worker_async }
        expect(Sidekiq::Status.get(worker_immediate, :result))
          .to include("Failed to create exprate")
      end
    end
  end
end
