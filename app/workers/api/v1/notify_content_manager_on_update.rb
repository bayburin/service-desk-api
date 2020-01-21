module Api
  module V1
    class NotifyContentManagerOnUpdate
      include Sidekiq::Worker

      def perform(user_id, ticket_id, current_user_id, origin)
        delivery_user = User.find(user_id).load_details
        ticket = Ticket.find(ticket_id)
        current_user = User.find(current_user_id).load_details
        ReportSender.new(delivery_user, ticket, current_user, origin).send_report(Tickets::TicketUpdatedEmailSender.new)
      end
    end
  end
end
