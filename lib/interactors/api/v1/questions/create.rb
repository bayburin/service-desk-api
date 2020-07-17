module Api
  module V1
    module Questions
      class Create
        include Interactor

        def call
          # Блокировка таблицы tickets для генерации поля identity
          Ticket.with_advisory_lock('create_question') do
            create_form = Questions::QuestionForm.new(Question.new)

            if create_form.validate(context.params) && create_form.save
              context.question = create_form.model
            else
              context.fail!(errors: create_form.errors)
            end
          end
        end
      end
    end
  end
end
