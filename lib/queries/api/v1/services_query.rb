module Api
  module V1
    class ServicesQuery < ApplicationQuery
      delegate :visible, to: :all

      def initialize(scope = Service.all)
        @scope = scope.extend(ServiceScope)
      end

      def all
        scope.by_popularity.extend(ServiceScope)
      end

      def allowed_to_create_app
        visible.where(has_common_case: true)
      end

      def most_popular
        visible.limit(6)
      end

      def search_by_responsible(user)
        all.left_outer_joins(:tickets).by_responsible(user)
          .or(visible.left_outer_joins(:tickets))
          .or(all.by_tickets_responsible(user))
          .uniq
      end
    end
  end
end
