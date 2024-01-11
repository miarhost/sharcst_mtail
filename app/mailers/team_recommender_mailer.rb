class TeamRecommenderMailer < ApplicationMailer
  layout 'recommend_by_team'

  def recommend_by_team
    @user = params[:user]
    @recs = params[:recs]
    mail(to: @user.email, subject: "Team shares the links for #{Date.today.strftime('%B')}")
    Rails.logger.info "Delivered to #{@user.email}"
  rescue => e
    puts e.message
  end
end
