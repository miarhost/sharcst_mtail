require 'rails_helper'

RSpec.describe Webhook, 'validations' do
  it { is_expected.to validate_presence_of :url }
  it { is_expected.to validate :url_plug }
end
