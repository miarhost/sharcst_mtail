class UploadPolicy < ApplicationPolicy
  def dashboard?
    user_is_admin?
  end
end
