module Api
  module V1
    class TicketsQuery < ApplicationQuery
      delegate :visible, to: :all

      def initialize(scope = Ticket.all)
        @scope = scope
      end

      def all
        tickets.by_popularity
      end

      def by_responsible(user)
        all.by_responsible(user).or(visible)
      end

      def all_in_service(service)
        all.where(service: service)
      end

      # visible.or(where())

      private

      def tickets
        scope.where.not(ticketable_type: :FreeApplication).extend(Scope)
      end
    end
  end
end
