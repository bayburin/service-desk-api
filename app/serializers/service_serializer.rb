class ServiceSerializer < ActiveModel::Serializer
  attributes :id, :category_id, :name, :short_description, :install, :is_hidden, :has_common_case, :popularity

  has_many :tickets, if: :include_associations?

  belongs_to :category, if: :include_associations?

  def include_associations?
    !object.without_associations
  end

  def tickets
    scope = Api::V1::TicketsQuery.new(object.tickets).visible
    scope = scope.includes(:answers) unless object.tickets.any?(&:without_associations)
    scope
  end
end
