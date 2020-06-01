module Api
  module V1
    class ContentManagerMailer < ApplicationMailer
      default from: 'uivt06@iss-reshetnev.ru'

      def question_created_email(delivery_user, ticket, current_user, origin)
        unless delivery_user.details&.email
          Rails.logger.info { "Email по табельному #{delivery_user.tn} не получен" }

          return
        end

        @delivery_user = delivery_user
        @question = QuestionDecorator.new(ticket.ticketable)
        @current_user = current_user
        @origin = origin

        mail to: "#{@delivery_user.details.full_name} <#{@delivery_user.details.email}>", subject: "Портал \"Техподдержка УИВТ\": добавлен новый вопрос №#{ticket.id}"
      end

      def question_updated_email(delivery_user, ticket, current_user, origin)
        unless delivery_user.details&.email
          Rails.logger.info { "Email по табельному #{delivery_user.tn} не получен" }

          return
        end

        @delivery_user = delivery_user
        @question = QuestionDecorator.new(ticket.ticketable)
        @current_user = current_user
        @origin = origin
        @updated_date = ticket.published_state? ? @question.correction.updated_at : @question.updated_at

        mail to: "#{@delivery_user.details.full_name} <#{@delivery_user.details.email}>", subject: "Портал \"Техподдержка УИВТ\": вопрос №#{ticket.id} изменен"
      end
    end
  end
end
