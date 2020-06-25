module Api
  module V1
    module Questions
      class QuestionResponsibleUserSerializer < QuestionBaseSerializer
        has_one :correction, if: :include_associations?, serializer: Questions::QuestionResponsibleUserSerializer

        belongs_to :ticket, serializer: Api::V1::Tickets::TicketResponsibleUserSerializer
      end
    end
  end
end
