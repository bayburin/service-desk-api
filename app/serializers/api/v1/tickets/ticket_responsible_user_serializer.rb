module Api
  module V1
    module Tickets
      class TicketResponsibleUserSerializer < TicketBaseSerializer
        has_many :responsible_users, if: :include_associations?, serializer: ResponsibleUserSerializer
        has_many :tags, if: :include_associations?
      end
    end
  end
end
