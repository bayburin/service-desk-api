module Api
  module V1
    module QuestionTickets
      class QuestionTicketResponsibleUserSerializer < QuestionTicketBaseSerializer
        has_one :correction, if: :include_associations?, serializer: QuestionTickets::QuestionTicketResponsibleUserSerializer

        belongs_to :ticket, serializer: Api::V1::Tickets::TicketResponsibleUserSerializer
      end
    end
  end
end
