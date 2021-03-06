module Api
  module V1
    class NotifyContentManagerOnUpdateQuestion
      include Sidekiq::Worker

      def perform(user_id, ticket_id, current_user_tn, origin)
        delivery_user = User.find(user_id).load_details
        ticket = Ticket.find(ticket_id)
        current_user = User.authenticate(tn: current_user_tn).load_details
        return if delivery_user.tn == current_user.tn

        ReportSender.new(delivery_user, ticket, current_user: current_user, origin: origin).send_report(Reporter::QuestionUpdatedEmailSender.new)
      end
    end
  end
end
