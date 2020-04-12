module Api
  module V1
    module Services
      class ServiceGuestSerializer < ServiceBaseSerializer
        # has_many :tickets, if: :include_associations?, serializer: Tickets::TicketGuestSerializer do |serializer|
        #   tickets_scope = TicketsQuery.new(serializer.object.tickets).visible.published_state
        #   serializer.include_authorize_attributes_for(tickets_scope)
        # end

        has_many :question_tickets, if: :include_associations?, serializer: QuestionTickets::QuestionTicketGuestSerializer do |serializer|
          tickets_scope = QuestionTicketsQuery.new(serializer.object.question_tickets).visible.published
          serializer.include_authorize_attributes_for(tickets_scope)
        end
      end
    end
  end
end
