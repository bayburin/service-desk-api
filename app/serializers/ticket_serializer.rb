class TicketSerializer < ActiveModel::Serializer
  attributes :id, :service_id, :name, :popularity

  has_many :solutions
  has_many :tags
end
