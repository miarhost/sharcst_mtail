class Mailers::TeamRecommenderMailJob
  include Sidekiq::Job

  sidekiq_options queue: :mailer, retry: 4, backtrace: 3

  def perform
    recs = DiscoRecommendationsQueries.group_team_recs

    recs.each do |pair|
      Team.find(pair[0]['team_id']).users.each do |user|
        TeamRecommenderMailer.with(user: user, recs: pair[1]['uploads_ids'])
          .recommend_by_team
          .deliver_now
      end
    end
  end
end
