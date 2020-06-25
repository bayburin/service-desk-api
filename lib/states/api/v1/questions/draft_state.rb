module Api
  module V1
    module Questions
      class DraftState < AbstractState
        def update(attributes)
          question.update(attributes)
        end

        def publish
          if question.original
            popularity = question.original.ticket.popularity

            Question.transaction do
              question.original.destroy && question.ticket.update(state: :published, popularity: popularity)
            end
          else
            question.ticket.update(state: :published)
          end
        end

        def destroy
          question.destroy
        end
      end
    end
  end
end
