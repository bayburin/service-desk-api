class TicketSerializer < ActiveModel::Serializer
  attributes :id, :service_id, :name, :ticket_type, :is_hidden, :sla, :popularity

  has_many :answers
  has_many :tags
  belongs_to :service, if: :include_service?

  def include_service?
    !(object.without_associations || object.without_service)
  end
end
