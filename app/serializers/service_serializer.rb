class ServiceSerializer < ActiveModel::Serializer
  attributes :id, :category_id, :name, :short_description, :install, :is_hidden, :has_common_case, :popularity

  has_many :tickets, if: :include_associations?
  has_many :responsible_users, if: :include_associations?

  belongs_to :category, if: :include_associations?

  def include_associations?
    !object.without_associations
  end

  def tickets
    # scope = TicketPolicy::Scope.new(current_user, object.tickets).resolve(object)
    scope = Api::V1::TicketsQuery.new(object.tickets).visible.published_state
    scope = scope.includes(:responsible_users, :tags, answers: :attachments) unless object.tickets.any?(&:without_associations)
    scope
  end
end
