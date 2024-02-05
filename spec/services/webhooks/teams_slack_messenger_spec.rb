require 'rails_helper'
describe Webhooks::TeamsSlackMessenger, type: :service do
  let(:payload) { "https://example.com?download=, https://example1.com?download=, https://example2.com?download=" }
  describe '.call' do
    it 'processes post request to slack teams endpoint' do
      response = described_class.call(payload)
      expect(response.body).to eq("Sent to channel")
    end
  end
end
