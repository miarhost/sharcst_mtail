class ExternalRecsMailer < ApplicationMailer

  def weekly_links
    @newsletter = Newsletter.find(params[:nid])
    @user = User.find(params[:uid])
    mail(to: @user.email, subject: "#{@newsletter.header} for #{@newsletter.date}")
  end
end
