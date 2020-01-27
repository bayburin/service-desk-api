module Api
  module V1
    class UsersQuery < ApplicationQuery
      def initialize(scope = User.all)
        @scope = scope
      end

      def managers
        scope.where(role: Role.find_by(name: :content_manager))
      end
    end
  end
end
