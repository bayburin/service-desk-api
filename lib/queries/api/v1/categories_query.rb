module Api
  module V1
    class CategoriesQuery < ApplicationQuery
      def initialize(scope = Category.all)
        @scope = scope.extend(Scope)
      end

      def all
        scope.includes(:services).by_popularity
      end

      def visible
        all.visible
      end
    end
  end
end
