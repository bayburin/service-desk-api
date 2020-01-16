module Api
  module V1
    module Tickets
      class TicketChangedEmailSender
        def send(delivery_user, ticket, current_user)
          ContentManagerMailer.question_changed_email(delivery_user, ticket, current_user).deliver_now
        end
      end
    end
  end
end
