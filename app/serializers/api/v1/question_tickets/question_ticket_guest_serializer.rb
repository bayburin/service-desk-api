module Api
  module V1
    module QuestionTickets
      class QuestionTicketGuestSerializer < QuestionTicketBaseSerializer
        belongs_to :ticket, serializer: Api::V1::Tickets::TicketGuestSerializer

        def answers
          object.answers.includes(:attachments).extend(Scope).visible
        end
      end
    end
  end
end
