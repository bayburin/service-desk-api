module Api
  module V1
    module Questions
      # Объект формы модели Question
      class QuestionForm < TicketableForm
        property :id
        property :original_id
        collection :answers, form: AnswerForm, populate_if_empty: Answer, populator: :populate_answers!

        protected

        # Обработка ответов
        def populate_answers!(fragment:, **)
          item = answers.find { |answer| answer.id == fragment[:id].to_i }

          if fragment[:_destroy].to_s == 'true'
            answers.delete(item)
            return skip!
          end

          item || answers.append(Answer.new)
        end
      end
    end
  end
end
