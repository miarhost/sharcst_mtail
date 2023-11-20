class NewsletterPolicy < ApplicationPolicy
 def sms_users_newsletter?
  user_is_admin?
 end

 def update?
  user_is_admin?
 end
end
