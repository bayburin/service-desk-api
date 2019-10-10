module Api
  module V1
    class CaseSerializer < ActiveModel::Serializer
      attributes :case_id, :service_id, :ticket_id, :user_tn, :id_tn, :user_info, :host_id, :item_id, :desc, :phone, :email, :mobile,
                 :status_id, :status, :runtime, :rating

      belongs_to :service, serializer: Services::ServiceBaseSerializer
      belongs_to :ticket, serializer: Tickets::TicketBaseSerializer

      def runtime
        ActiveModelSerializers::SerializableResource.new(object.runtime).serializable_hash
      end
    end
  end
end
