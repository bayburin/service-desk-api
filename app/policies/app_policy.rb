class AppPolicy < ApplicationPolicy
  def create?
    user_matсh?
  end

  def update?
    user_matсh?
  end

  class Scope < Scope
    def resolve
      scope.where(user_tn: user.tn)
    end
  end

  protected

  def user_matсh?
    record.user_tn.to_i == user.tn.to_i
  end
end
