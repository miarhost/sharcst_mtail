module Update
  class FillRecGroupWorker
    include Sidekiq::Worker
    include Sidekiq::Status::Worker
    sidekiq_options queue: :updater

    def perform(record_id)
      collector = DataSets::StatFieldSet.new(record_id, 'Category')
      uploads_recs_field = collector.collect_upload_recs
      user_ids = collector.user_ids
      infos_json = collector.collect_infos_recs

      stat_record = RecommendationsStat.create!(statable: CategoryStat.new(
        uploads_recs: uploads_recs_field,
        infos_ratings: infos_json,
        user_ids: user_ids,
        category_id: record_id
      ))

      store result: {"#{Time.now}": "CategoryStat #{stat_record.id} created"}.to_json
    rescue StandardError => e
      store result: e.message
      Rails.logger.error(e.message)
    end
  end
end
