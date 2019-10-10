module Api
  module V1
    module Services
      class ServiceGuestSerializer < ServiceBaseSerializer
        has_many :tickets, if: :include_associations?, serializer: Tickets::TicketGuestSerializer do |serializer|
          tickets_scope = TicketsQuery.new(serializer.object.tickets).visible.published_state
          serializer.include_authorize_attributes_for(tickets_scope)
        end
      end
    end
  end
end
