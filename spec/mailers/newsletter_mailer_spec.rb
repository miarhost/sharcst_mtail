require 'rails_helper'
describe 'NewsletterMailer', type: :mailer do
  describe '#current_news' do
    let!(:subscription) { create(:subscription) }
    let!(:newsletter) { create(:newsletter, subscription_id: subscription.id) }
    let!(:user) { create(:user, subscription_ids: [subscription.id])}

    subject(:mail) { NewsletterMailer.with(user: user, newsletter: newsletter).current_news.deliver_now }

    it 'sends email to a user email' do
      expect(mail.to).to include(user.email)
      expect(mail.subject).to eq(newsletter.header)
    end

    it 'has an expected body' do
      expect(mail.body).to eq(newsletter.body.to_s)
    end
  end
end
