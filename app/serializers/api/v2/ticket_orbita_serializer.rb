module Api
  module V2
    class TicketOrbitaSerializer < ActiveModel::Serializer
      attributes :id, :identity, :service_id, :name, :ticketable_id, :ticketable_type, :sla, :state, :responsible_users

      belongs_to :service, serializer: ServiceOrbitaSerializer

      def responsible_users
        arr = object.responsible_users + object.service.responsible_users
        ActiveModelSerializers::SerializableResource.new(arr, each_serializer: ResponsibleUserSerializer)
      end
    end
  end
end
