module Api
  module V1
    module AppTemplates
      # Класс оборачивающий процесс создания формы заявки.
      class Create
        include Interactor

        def call
          # Блокировка таблицы tickets для генерации поля identity
          Ticket.with_advisory_lock('create_ticket') do
            create_form = AppTemplateForm.new(AppTemplate.new)

            if create_form.validate(context.params) && create_form.save
              context.app_template = create_form.model
            else
              context.fail!(errors: create_form.errors)
            end
          end
        end
      end
    end
  end
end
