require 'rails_helper'
require 'bunny'

describe ImportanceListDeliverQueue, type: :queue do
  let!(:message) { [{"importance": 0.0, "item_id": 1}] }
  let!(:queue_name) { described_class.queue_name }
  let!(:exchange_name) { described_class.exchange_name }

  describe '#execute' do
    it 'starts queue and sends a message' do
      expect(BasicPublisher).to receive(:direct_exchange)
        .with(exchange_name, queue_name, message.to_json)
      expect(Rails.logger).to receive(:info)
        .with("Importances payload sent to consumer at #{Time.now}")
      described_class.execute(message)
    end
 end
end
