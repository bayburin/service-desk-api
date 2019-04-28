module Api
  module V1
    class TicketsQuery < ApplicationQuery
      def initialize(scope = Ticket.all)
        @scope = scope.extend(Scope)
      end

      def all
        tickets.by_popularity
      end

      def visible
        tickets.visible.by_popularity
      end

      private

      def tickets
        scope.where.not(ticket_type: :common_case)
      end
    end
  end
end
