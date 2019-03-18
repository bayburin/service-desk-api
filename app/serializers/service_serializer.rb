class ServiceSerializer < ActiveModel::Serializer
  attributes :id, :category_id, :name, :short_description, :install, :is_sla, :sla, :popularity

  has_many :tickets, if: :include_tickets?

  def include_tickets?
    !object.without_associations
  end
end
