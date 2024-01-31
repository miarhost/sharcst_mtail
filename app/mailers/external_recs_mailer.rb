class ExternalRecsMailer < ApplicationMailer

  def weekly_links
    @newsletter = params[:newsletter]
    mail(to: params[:email], subject: "#{@newsletter.header} for #{@newsletter.date}")
  end
end
