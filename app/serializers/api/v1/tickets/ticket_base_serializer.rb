module Api
  module V1
    module Tickets
      class TicketBaseSerializer < ActiveModel::Serializer
        attributes :id, :service_id, :name, :ticket_type, :state, :is_hidden, :sla, :popularity

        has_many :answers, if: :include_associations?

        belongs_to :service, serializer: Services::ServiceBaseSerializer

        def include_associations?
          !object.without_associations
        end
      end
    end
  end
end
