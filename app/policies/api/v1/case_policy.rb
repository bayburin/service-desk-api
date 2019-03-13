class CasePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(tn: user.tn)
    end
  end
end
