class ServiceSerializer < ActiveModel::Serializer
  attributes :id, :category_id, :name, :short_description, :install, :is_hidden, :has_common_case, :popularity

  has_many :tickets, if: :include_associations?

  belongs_to :category, if: :include_associations?

  def include_associations?
    !object.without_associations
  end

  def tickets
    scope = TicketPolicy::Scope.new(current_user, object.tickets).resolve(object)
    scope = scope.includes(answers: :attachments) unless object.tickets.any?(&:without_associations)
    scope
  end
end
