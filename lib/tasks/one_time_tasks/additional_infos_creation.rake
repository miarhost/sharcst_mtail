namespace :one_time_tasks do
  desc 'additional_infos_creation'
  task create_infos: :environment do
    ActiveRecord::Base.transaction do
      UploadsInfo.create!([
                            { user_id: 1, upload_id: 1, rating: 0, log_tag: 'http', name: 'First test Uploads Info',
                              media_type: 2, description: 'The First test Uploads Info for the response at reports data', duration: 10_000, provider: 'NemiStudio' },
                            { user_id: 1, upload_id: 1, rating: 0, log_tag: 'http', name: 'Info Upload 2',
                              media_type: 1, description: 'Info Upload 2 reporting', duration: 10_000, provider: 'TFS' },
                            { user_id: 1, upload_id: 1, rating: 0, log_tag: 'http', name: 'Info Upload 2',
                              media_type: 3, description: 'Info Upload 3 reporting', duration: 10_000, provider: 'The HASH', streaming_infos: { 'the hash' => 22, 'nemi_studio' => 0, report_email: '123@mail.c' } }
                          ])
    end
  end
end
