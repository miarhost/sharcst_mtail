class WebhookPolicy < ApplicationPolicy

  def messenger_alert_for_admins?
    user_is_admin?
  end
end
