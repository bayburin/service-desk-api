class TicketSerializer < ActiveModel::Serializer
  attributes :id, :service_id, :name, :ticket_type, :state, :is_hidden, :sla, :popularity

  has_many :answers, if: :include_associations?
  has_many :responsible_users, if: :include_associations?
  has_many :tags, if: :include_associations?

  belongs_to :service

  def include_associations?
    !object.without_associations
  end
end
