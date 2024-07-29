require 'rails_helper'

describe Update::FillRecsStatWorker, type: :worker do
  let!(:category) { create(:category)}
  let(:subject) { described_class.new }

  after do
    Sidekiq::Testing.fake!
  end

  describe "#perform" do
    it 'got to an updaters queue' do
      expect(subject.sidekiq_options_hash['queue']).to eq(:updater)
    end

    it 'performs creating stat unit' do
      expect do
        subject.perform(category.id)
        sleep 1
      end.to change(RecommendationsStat, :count).by(1)
    end
  end
end
