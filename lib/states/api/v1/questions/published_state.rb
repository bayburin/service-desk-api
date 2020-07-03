module Api
  module V1
    module Questions
      class PublishedState < AbstractState
        def update(attributes)
          update_ticket = UpdatePublished.new(question, attributes)
          return true if update_ticket.call

          question.errors.merge!(update_ticket.errors)
          false
        end

        def publish
          raise 'Вопрос уже опубликован'
        end

        def destroy
          if question.correction
            Question.transaction do
              question.correction.destroy && question.destroy
            end
          else
            question.destroy
          end
        end
      end
    end
  end
end
