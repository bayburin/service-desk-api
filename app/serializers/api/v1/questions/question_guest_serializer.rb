module Api
  module V1
    module Questions
      class QuestionGuestSerializer < QuestionBaseSerializer
        belongs_to :ticket, serializer: Api::V1::Tickets::TicketGuestSerializer

        def answers
          object.answers.includes(:attachments).extend(Scope).visible
        end
      end
    end
  end
end
