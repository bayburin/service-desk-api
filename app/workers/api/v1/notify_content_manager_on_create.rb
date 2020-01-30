module Api
  module V1
    class NotifyContentManagerOnCreate
      include Sidekiq::Worker

      def perform(user_id, ticket_id, current_user_tn, origin)
        delivery_user = User.find(user_id).load_details
        ticket = Ticket.find(ticket_id)
        current_user = User.authenticate(tn: current_user_tn).load_details
        ReportSender.new(delivery_user, ticket, current_user, origin).send_report(Tickets::TicketCreatedEmailSender.new)
      end
    end
  end
end
