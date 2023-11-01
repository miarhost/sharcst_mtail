namespace :subscriptions do
  desc 'Update subscriptions ratings up to user preferences'
  task update_subscriptions_ratings: :environment do
    RatingsQuery.new(Subscription.without_infos_ratings).subs_with_users_recent_upload_infos.each do |sub|
      uiids = RatingsQuery.new(UploadsInfo).infos_for_subscription_to_update.ids
      payload = { 'info_ratings': DiscoServices::UploadsRecommender.call(uiids) }
      ActiveRecord::Base.transaction do
        sub.update!(uploads_infos_ratings: payload)

        uploads = RatingsQuery.new(Upload).selected_uploads
        uploads.each { |u| u.update_recommended_uploads_infos }
      rescue => e
          Rails.logger.error("Errors processing ratings update on subscription #{sub.id}: #{e.message}")
          raise ActiveRecord::Rollback
      end
    end
  end
end
