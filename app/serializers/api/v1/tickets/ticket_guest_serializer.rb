module Api
  module V1
    module Tickets
      class TicketGuestSerializer < TicketBaseSerializer
        def answers
          object.answers.includes(:attachments).extend(Scope).visible
        end
      end
    end
  end
end
