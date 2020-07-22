module Api
  module V1
    class EventsQuery < ApplicationQuery
      def initialize(scope = Ahoy::Event.all)
        @scope = scope
      end

      def all_search_by(date)
        @scope = scope.where(name: 'Search').or(scope.where(name: 'Deep Search'))
        scope.where('DATE(time) = ?', date)
      end
    end
  end
end
