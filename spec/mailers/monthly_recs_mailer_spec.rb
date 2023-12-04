
require 'rails_helper'
require 'disco'
require 'ahoy'
  describe 'MonthlyRecsMailer', type: :mailer do
  let!(:user) { create(:user)}
  let!(:user_1) { create(:user)}
  let(:ahoy_visit) { create(:ahoy_visit, user_id: user_1.id) }
  let!(:upload_1) { create(:upload, user_id: user_1.id, date: Date.yesterday) }
  let!(:user_2) { create(:user)}
  let!(:upload_2) { create(:upload, user_id: user_2.id, date: Date.today.prev_week) }
  let!(:uploads_info) { create(:uploads_info, upload_id: upload_1.id, user_id: user_1.id)}
  let!(:uploads_info) { create(:uploads_info, upload_id: upload_2.id, user_id: user_2.id)}
  let!(:uploads_info) { create(:uploads_info, upload_id: upload_2.id, user_id: user.id)}
  let!(:recommendations) { DiscoServices::MonthlySubscriberRecommender.call(user) }
  let!(:subscription) { create(:subscription, uploads_ratings: {'r': 1})}
  let!(:subscription_1) { create(:subscription, uploads_ratings: {'r': 0})}

  describe '#recommend_per_user' do
    subject(:mail) { MonthlyRecsMailer.with(user: user, recommendations: recommendations).recommend_per_user.deliver_now }

    it "sends email to user's address" do
      expect(mail.to).to include(user.email)
      expect(mail.subject).to include('Your preferences')
    end

    it 'has predictions for user by ratings from recommendations at mail body' do
      expect(mail.body).to include(recommendations[:future_rating][0])
    end
  end
end
