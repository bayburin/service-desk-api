module Api
  module V1
    module Questions
      # Объект формы модели Question
      class QuestionForm < Reform::Form
        property :id
        property :original_id
        property :ticket, form: TicketForm, populate_if_empty: Ticket
        collection :answers, form: AnswerForm, populate_if_empty: Answer, populator: :populate_answers!

        validate :validate_ticket

        def validate(params)
          ticket&.populate_collections(params[:ticket]) if params[:ticket]

          super(params)
        end

        def save
          ::ActiveRecord::Base.transaction do
            super
          end
        end

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

        # Валидация формы TicketForm
        def validate_ticket
          errors.add(:ticket, ticket.errors) unless ticket.valid?
        end
      end
    end
  end
end
