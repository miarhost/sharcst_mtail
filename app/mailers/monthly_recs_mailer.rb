
class MontlyRecsMailer < ApplicationMailer
  layout 'recommend_per_user'

  def recommend_per_user(user, recommendations)
    @user = user
    @recommendations = recommendations
    mail(to: @user.email, subject: "Your preferences at #{Date.today.strftime('%B')} #{Date.today.year}")
    Rails.logger.info "Delivered to #{@user.email}"
  rescue => e
    Rails.logger.error(e.message)
  end
end
