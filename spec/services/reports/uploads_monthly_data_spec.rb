require 'rails_helper'
require 'csv'
require 'disco'

describe Reports::UploadsMonthlyData, type: :service do
  let!(:user) { create(:user)}
  let!(:user_1) { create(:user, subscription_ids: [subscription.id])}
  let!(:upload_1) { create(:upload, user_id: user_1.id, date: Date.yesterday) }
  let!(:user_2) { create(:user)}
  let!(:upload_2) { create(:upload, user_id: user_2.id, date: Date.today.prev_week) }
  let!(:uploads_info_1) { create(:uploads_info, upload_id: upload_1.id, user_id: user_1.id)}
  let!(:uploads_info_2) { create(:uploads_info, upload_id: upload_2.id, user_id: user_2.id)}
  let!(:uploads_info_3) { create(:uploads_info, upload_id: upload_2.id, user_id: user.id)}
  let!(:recommendations) { DiscoServices::MonthlySubscriberRecommender.call(user) }
  let!(:subscription) { create(:subscription, uploads_ratings: {'r': 1})}
  let!(:subscription_1) { create(:subscription, uploads_ratings: {'r': 0})}

  describe '.call' do
    before do
      described_class.call(uploads_info_3.id)
    end

    let!(:csv) { CSV.parse(uploads_info_3.uploads_info_attacments.last.download) }

    context 'csv report with attachments infos is successfully generated' do
      it 'creates csv file with proper headers' do
        expect(csv[0]).to eq(
          [
            'user_id',
            'max predicted rating',
            'provider',
            'subscription',
            'used_recommendations'
          ]
        )
      end

      it 'creates csv file with proper data row' do
        expect(csv[1]).to eq(
          [
            uploads_info_1.user_id.to_s,
            "[#{subscription.uploads_ratings.to_h.values.max}]",
            uploads_info_1.provider,
            subscription.title,
            uploads_info_1.user.recommended_uploads.pluck(:name).join(', ')
          ]
        )
      end
    end
  end
end
