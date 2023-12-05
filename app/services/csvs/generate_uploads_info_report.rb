require 'csv'
require 'tempfile'

class Csvs::GenerateUploadsInfoReport
  def initialize(record_id)
    @record = UploadsInfo.find(record_id)
  end

  def self.call(*args)
    new(*args).call
  end

  def call
    generate_report
  end

  private

  def generate_report
    file = Tempfile.new
    errors = ''
    begin
      CSV.open(file, 'wb') do |csv|
        csv << prepare_headers

        csv << prepare_rows
      end
      attachment = @record.uploads_info_attacments.build
      attachment.attach(
        io: file,
        filename: "report for UploadsInfo #{@record.id} to #{@record.upload.user.email}",
        content_type: 'application/csv'
      )
      attachment.save!
    rescue StandardError => e
      puts e.message + 'interrupted report generation for UploadsInfo' + @record.id.to_s
      file.close
      file.unlink
      errors = e.message
    end
    errors.blank? ? attachment : { 'error': e.message }
  end

  def prepare_headers
    rows =
      [
        'Name',
        'Number of seeds',
        'Duration',
        'User',
        'Uploads',
        'Protocol'
      ]
    rows
  end

  def prepare_rows
    rows = []
    rows << @record&.name
    rows << @record&.number_of_seeds
    rows << @record&.duration
    rows << @record.user.try(:email)
    rows << @record.user.uploads&.size
    rows << @record&.protocol
    rows
  end
end
