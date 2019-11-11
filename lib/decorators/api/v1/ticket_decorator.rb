module Api
  module V1
    class TicketDecorator < SimpleDelegator
      def initialize(ticket)
        __setobj__ ticket
      end

      def update_by_state(attributes)
        ticket_state.update(attributes) ? reload : false
      end

      def publish
        ticket_state.publish
      end

      protected

      def ticket_state
        published_state? ? Api::V1::Tickets::PublishedState.new(self) : Api::V1::Tickets::DraftState.new(self)
      end
    end
  end
end
