require 'csv'
require 'tempfile'

class Reports::UploadsMonthlyData < ApplicationService
  def initialize(record_id)
    @record = UploadsInfo.find(record_id)
    @infos = RecordsForPeriod.new(UploadsInfo, Date.today.prev_month, Date.today)
             .infos_active_for_month
             .to_a
  end

  def call
    file = Tempfile.new
    errors = ''
    begin
      CSV.open(file, 'wb') do |csv|
        csv << [
          'user_id',
          'max predicted rating',
          'provider',
          'subscription',
          'used_recommendations']
        @infos.each do |record|
          csv << [
            record&.user_id,
            Subscription.where(id: record.user.subscription_ids).pluck(:uploads_ratings).map{|r| r.to_h.values.max} || 0,
            record.provider,
            Subscription.find_by(id: record.user.subscription_ids&.sample)&.title || 0,
            record.user.recommended_uploads.pluck(:name).join(', ')
            ]
        end
          csv << [
            'media_type',
            'upload_id',
            'downloads_count',
            'used_recommendations'
            ]
        @infos.each do |record|
          csv << [
            record&.media_type,
            record&.upload_id,
            record.upload.downloads_count,
            record.upload.recommended_uploads_infos.pluck(:name).join(', ')
          ]
        end
      end

      attachment = @record.uploads_info_attacments.build
      attachment.attach(
        io: file,
        filename: "report for UploadsInfos #{@record.id} / #{DateTime.now}",
        content_type: 'application/csv'
      )
      attachment.save!
    rescue StandardError => e
      puts e.message + 'interrupted report generation for UploadsInfos' + @record.id.to_s
      file.close
      file.unlink
      errors = e.message
    end
    errors.blank? ? attachment : { 'error': e.message }
  end
end
