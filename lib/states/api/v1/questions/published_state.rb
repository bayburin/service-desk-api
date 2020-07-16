module Api
  module V1
    module Questions
      class PublishedState < AbstractState
        def update(attributes)
          form = UpdatePublishedForm.new(question)
          return true if form.validate(attributes) && form.save

          question.errors.merge!(form.errors)
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
