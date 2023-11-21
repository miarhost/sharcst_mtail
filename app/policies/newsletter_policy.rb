class NewsletterPolicy < ApplicationPolicy
 def sms_users_newsletter?
  user_is_admin?
 end

 def update?
  user_is_admin?
 end

 def monthly_uploads_newsletter?
  user_is_admin?
 end

 def email_users_newsletter?
  user_is_admin?
 end
end
