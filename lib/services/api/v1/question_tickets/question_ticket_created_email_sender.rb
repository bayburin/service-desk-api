module Api
  module V1
    module QuestionTickets
      class QuestionTicketCreatedEmailSender
        def send(delivery_user, ticket, current_user, origin)
          ContentManagerMailer.question_created_email(delivery_user, ticket, current_user, origin).deliver_now
        end
      end
    end
  end
end
