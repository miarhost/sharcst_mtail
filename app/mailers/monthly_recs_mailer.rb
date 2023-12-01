
class MonthlyRecsMailer < ApplicationMailer
  layout 'recommend_per_user'

  def recommend_per_user
    @user = params[:user]
    @recommendations = params[:recommendations]
    mail(to: @user.email, subject: "Your preferences at #{Date.today.strftime('%B')} #{Date.today.year}")
    Rails.logger.info "Delivered to #{@user.email}"
  rescue => e
    puts e.message
  end
end
