class ApplicationMailer < ActionMailer::Base
  default from: ENV['MAIN_MAILER']
  layout 'mailer'
end
