class ExternalRecsMailer < ApplicationMailer

  def weekly_links
    @newsletter = Newsletter.find(params[:newsletter])
    @user = User.find(params[:user])
    mail(to: @user.email, subject: "#{@newsletter.header} for #{@newsletter.date}")
  end
end
