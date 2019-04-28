module Api
  module V1
    class TicketsQuery < ApplicationQuery
      def initialize(scope = Ticket.all)
        @scope = scope.extend(Scope)
      end

      def all
        scope.where.not(ticket_type: :common_case).by_popularity
      end
    end
  end
end
