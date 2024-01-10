class Mailers::TeamRecommenderMailJob
  include Sidekiq::Job
  include Sidekiq::Status::Worker

  sidekiq_options queue: :mailer, retry: 4, backtrace: 3

  def perform(team_id)
    recs = DiscoRecommendationsQueries.daily_recs_for_team(team_id)
    Team.find(team_id).users&.each do |user|
      TeamRecommenderMailer.with(user: user, recs: recs).recommend_by_team.deliver_now
    end
  end
end
