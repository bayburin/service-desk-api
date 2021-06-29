module Api
  module V1
    class AppSerializer < ActiveModel::Serializer
      attributes :case_id, :service_id, :ticket_id, :user_tn, :id_tn, :user_info, :host_id, :item_id, :barcode, :desc, :phone, :email,
                 :mobile, :status_id, :status, :runtime, :rating

      belongs_to :service, serializer: Services::ServiceGuestSerializer
      belongs_to :ticket, serializer: Tickets::TicketGuestSerializer

      def runtime
        ActiveModelSerializers::SerializableResource.new(object.runtime).serializable_hash
      end
    end
  end
end
