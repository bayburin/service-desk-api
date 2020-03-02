class UserPolicy < ApplicationPolicy
  def responsible_user_access?
    user.one_of_roles? :content_manager, :operator, :service_responsible
  end
end
