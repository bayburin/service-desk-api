module Api
  module V1
    class EventsQuery < ApplicationQuery
      def initialize(scope = Ahoy::Event.all)
        @scope = scope
      end

      def all_search_by(date)
        @scope = scope.searched.or(scope.deep_search)
        scope.where('DATE(time) = ?', date)
      end
    end
  end
end
