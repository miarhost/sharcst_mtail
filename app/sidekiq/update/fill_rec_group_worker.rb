module Update
  class FillRecGroupWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  sidekiq_options queue: :updater

    def perform(record_id)
      collector = DataSets::StatFieldSet.new(record_id)
      uploads_recs_field = collector.collect_upload_recs
      user_ids = collector.user_ids
      RecommendationsGroup.find_or_create_by!(
        type: 'CategoryStat',
        uploads_recs: uploads_recs_field,
        user_ids: user_ids
      )
      store result: {"#{Time.now}": "CategoryStat #{stat_record.id} created"}.to_json
    rescue StandardError => e
      store result: e.message
      Rails.logger.error(e.message)
    end
    end
  end
end
