require 'rails_helper'
describe Users::Authentication, type: :service do
  let!(:user) { create(:user) }

  context 'successfully sign an access token for a valid user' do

    it 'returns jwt token for valid credentials pair' do
      result = described_class.call(user.email, user.password)
      expect(result).to start_with('ey')
    end
  end

  context "doesn't provide token for invalid user" do

    it 'returns nil for not valid credentials pair' do
      result = described_class.call('invalid@email.com', user.password)
      expect(result).to be_nil
    end
  end
end
