module Api
  module V1
    class ContentManagerMailer < ApplicationMailer
      default from: 'monitoring@iss-reshetnev.ru'

      def question_changed_email(delivery_user, ticket, current_user)
        unless delivery_user.details&.email
          Rails.logger.info { "Email по табельному #{delivery_user.tn} не получен" }

          return
        end

        @delivery_user = delivery_user
        @ticket = ticket
        @current_user = current_user

        mail to: "#{@delivery_user.details.full_name} <#{@delivery_user.details.email}>", subject: "Портал \"Техподдержка УИВТ\": вопрос №#{@ticket.id} изменен"
      end
    end
  end
end
