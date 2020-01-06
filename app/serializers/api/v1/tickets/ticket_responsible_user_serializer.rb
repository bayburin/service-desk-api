module Api
  module V1
    module Tickets
      class TicketResponsibleUserSerializer < TicketBaseSerializer
        has_many :responsible_users, if: :include_associations?, serializer: ResponsibleUserSerializer
        has_many :tags, if: :include_associations?
        has_one :correction, if: :include_associations?, serializer: Tickets::TicketResponsibleUserSerializer
      end
    end
  end
end
