module Api
  module V1
    module Services
      class ServiceResponsibleUserSerializer < ServiceBaseSerializer
        has_many :tickets, if: :include_associations?, serializer: Tickets::TicketResponsibleUserSerializer do |serializer|
          tickets_scope = TicketsQuery.new(serializer.object.tickets).all.published_state
          tickets_scope = serializer.include_authorize_attributes_for(tickets_scope)

          tickets_scope
        end
      end
    end
  end
end
