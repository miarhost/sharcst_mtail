require 'rails_helper'
require 'csv'

describe Csvs::GenerateUploadsInfoReport, type: :service do
  let!(:user) { create(:user) }
  let!(:upload) { create(:upload) }
  let!(:uploads_infos) { create_list(:uploads_info, 3, upload_id: upload.id, user_id: user.id) }
  let!(:uploads_info) { create(:uploads_info, upload_id: upload.id, user_id: user.id) }

  describe '.call' do
    before do
      described_class.call(uploads_info.id)
    end

    let!(:csv) { CSV.parse(uploads_info.uploads_info_attacments.last.download) }

    context 'csv report with attachments infos is successfully generated' do
      it 'creates csv file with proper headers' do
        expect(csv[0]).to eq(
          [
            'Name',
            'Number of seeds',
            'Duration',
            'User',
            'Uploads',
            'Protocol'
          ]
        )
      end

      it 'creates csv file with proper data row' do
        expect(csv[1]).to eq(
          [
            uploads_info.name,
            uploads_info.number_of_seeds.to_s,
            uploads_info.duration.to_s,
            user.email,
            user.uploads.count.to_s,
            uploads_info.protocol
          ]
        )
      end
    end
  end
end
