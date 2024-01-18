class TeamPolicy < ApplicationPolicy
  def queue_parsing_by_category?
    user_is_admin?
  end
end
