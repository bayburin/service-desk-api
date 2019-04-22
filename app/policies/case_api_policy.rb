class CaseApiPolicy < Struct.new(:user, :record)
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.where(user_tn: user.tn)
    end
  end
end
