class CaseSerializer < ActiveModel::Serializer
  attributes :case_id, :service_id, :ticket_id, :user_tn, :id_tn, :user_info, :host_id, :item_id, :desc, :phone, :email, :mobile, :status_id, :status, :runtime, :rating

  belongs_to :service
  belongs_to :ticket

  def runtime
    ActiveModelSerializers::SerializableResource.new(object.runtime).serializable_hash
  end
end
