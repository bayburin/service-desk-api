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

      def allowed_to_create_case
        visible.where(has_common_case: true)
      end

      def most_popular
        all.limit(6)
      end

      def search_by_responsible(user)
        all.includes(:tickets).by_responsible(user)
          .or(visible.includes(:tickets))
          .or(all.by_tickets_responsible(user))
      end
    end
  end
end
