require 'rails_helper'

describe Update::FillRecsStatWorker, type: :worker do
  let!(:category) { create(:category)}
  let(:subject) { described_class.new }
  let(:worker_action) { Sidekiq::Testing.inline! { subject.perform(category.id) } }

  after { Sidekiq::Testing.fake! }

  describe "#perform" do
    it 'got to an updaters queue' do
      expect(subject.sidekiq_options_hash['queue']).to eq(:updater)
    end

    it 'performs creating stat unit' do

      expect{ worker_action }.to change(RecommendationsStat, :count).by(1)
    end
  end
end
