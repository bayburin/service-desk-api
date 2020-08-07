module Api
  module V1
    class EventsQuery < ApplicationQuery
      def initialize(scope = Ahoy::Event.all)
        @scope = scope
      end

      def all_search_result_by(date)
        @scope = scope.searched_result.or(scope.deep_searched_result)
        scope.where('DATE(time) = ?', date)
      end
    end
  end
end
