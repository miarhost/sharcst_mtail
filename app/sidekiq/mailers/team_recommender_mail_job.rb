class Mailers::TeamRecommenderMailJob
  include Sidekiq::Job

  sidekiq_options queue: :mailer, retry: 4, backtrace: 3

  def perform
    recs = DiscoRecommendationsQueries.last_recs
    recs.each do |pair|
      Team.find(pair[:team_id]).users&.each do |user|
        TeamRecommenderMailer.with(user: user, recs: pair[:recs])
          .recommend_by_team
          .deliver_now
      end
    end
  end
end
