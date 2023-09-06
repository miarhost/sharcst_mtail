require 'rails_helper'

RSpec.describe User, 'validations' do
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to validate_format_of(:email) }
end
