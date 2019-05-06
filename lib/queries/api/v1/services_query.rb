module Api
  module V1
    class ServicesQuery < ApplicationQuery
      def initialize(scope = Service.all)
        @scope = scope.extend(Scope)
      end

      def all
        scope.by_popularity
      end

      def visible
        all.visible
      end

      def most_popular
        all.limit(6)
      end
    end
  end
end
