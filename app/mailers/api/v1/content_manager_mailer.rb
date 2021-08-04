module Api
  module V1
    class ContentManagerMailer < ApplicationMailer
      default from: 'uivt06@iss-reshetnev.ru'

      # Отправляет email с уведомлением о создании вопроса.
      def question_created_email(delivery_user, ticket, current_user:, origin:)
        unless delivery_user.details&.email
          Rails.logger.info { "Email по табельному #{delivery_user.tn} не получен" }

          return
        end

        @question = QuestionDecorator.new(ticket.ticketable)
        @current_user = current_user
        @origin = origin

        mail(
          to: "#{delivery_user.details.full_name} <#{delivery_user.details.email}>",
          subject: "Портал \"Техподдержка УИВТ\": добавлен новый вопрос №#{ticket.id}"
        )
      end

      # Отправляет email с уведомлением об изменении вопроса.
      def question_updated_email(delivery_user, ticket, current_user:, origin:)
        unless delivery_user.details&.email
          Rails.logger.info { "Email по табельному #{delivery_user.tn} не получен" }

          return
        end

        @question = QuestionDecorator.new(ticket.ticketable)
        @current_user = current_user
        @origin = origin
        @updated_date = ticket.published_state? ? @question.updated_at : @question.correction.updated_at

        mail(
          to: "#{delivery_user.details.full_name} <#{delivery_user.details.email}>",
          subject: "Портал \"Техподдержка УИВТ\": вопрос №#{ticket.id} изменен"
        )
      end

      # Отправляет email с суточной поисковой статистикой.
      def search_daily_statistics_email(delivery_user, search_list, date:)
        @date = Date.strptime(date).strftime('%d.%m.%Y')
        @search_list = search_list
        attachments['Запросы.pdf'] = WickedPdf.new.pdf_from_string(
          render_to_string('api/v1/pdfs/search_daily_statistics', layout: 'pdf.html.erb')
        )

        mail(
          to: "#{delivery_user.details.full_name} <#{delivery_user.details.email}>",
          subject: "Портал \"Техподдержка УИВТ\": поисковые запросы пользователей за #{@date}"
        )
      end
    end
  end
end
