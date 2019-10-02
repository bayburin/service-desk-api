module Api
  module V1
    class TicketDecorator < SimpleDelegator
      def initialize(ticket)
        __setobj__ ticket
      end

      def update_by_state(attributes)
        state = published_state? ? Api::V1::Tickets::PublishedState.new(self) : Api::V1::Tickets::DraftState.new(self)

        if state.update(attributes)
          state.object
        else
          errors.merge!(state.object.errors)

          false
        end
      end
    end
  end
end
