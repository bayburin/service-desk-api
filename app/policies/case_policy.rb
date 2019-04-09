class CasePolicy < ApplicationPolicy
  def create?
    user_matсh?
  end

  class Scope < Scope
    def resolve
      scope.where(tn: user.tn)
    end
  end

  protected

  def user_matсh?
    record.user_tn.to_i == user.tn.to_i
  end
end
