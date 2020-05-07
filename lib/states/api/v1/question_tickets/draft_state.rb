module Api
  module V1
    module QuestionTickets
      class DraftState < AbstractState
        def update(attributes)
          question_ticket.update(attributes)
        end

        def publish
          if question_ticket.original
            popularity = question_ticket.original.ticket.popularity

            QuestionTicket.transaction do
              question_ticket.original.destroy && question_ticket.ticket.update(state: :published, popularity: popularity)
            end
          else
            question_ticket.ticket.update(state: :published)
          end
        end

        def destroy
          question_ticket.destroy
        end
      end
    end
  end
end
