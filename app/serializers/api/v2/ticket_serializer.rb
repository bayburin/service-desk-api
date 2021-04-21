module Api
  module V2
    class TicketSerializer < ActiveModel::Serializer
      attributes :id, :identity, :service_id, :name, :ticketable_id, :ticketable_type, :state, :is_hidden, :sla, :popularity, :responsible_users

      belongs_to :service

      def responsible_users
        arr = object.responsible_users + object.service.responsible_users
        ActiveModelSerializers::SerializableResource.new(arr, each_serializer: ResponsibleUserSerializer)
      end
    end
  end
end
