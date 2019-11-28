module Api
  module V1
    class CategoriesQuery < ApplicationQuery
      def initialize(scope = Category.all)
        @scope = scope.extend(Scope)
      end

      def all
        scope.by_popularity
      end
    end
  end
end
