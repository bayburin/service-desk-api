module Api
  module V1
    module QuestionTickets
      class PublishedState < AbstractState
        def update(attributes)
          update_ticket = UpdatePublishedQuestion.new(question_ticket)
          return true if update_ticket.update(attributes)

          question_ticket.errors.merge!(update_ticket.errors)
          false
        end

        def publish
          raise 'Вопрос уже опубликован'
        end

        def destroy
          if question_ticket.correction
            QuestionTicket.transaction do
              question_ticket.correction.destroy && question_ticket.destroy
            end
          else
            question_ticket.destroy
          end
        end
      end
    end
  end
end
