class ServiceSerializer < ActiveModel::Serializer
  attributes :id, :category_id, :name, :short_description, :install, :is_hidden, :has_common_case, :popularity

  has_many :tickets, if: :include_associations?
  has_many :responsible_users, if: :include_associations?

  belongs_to :category, if: :include_associations?

  def include_associations?
    !object.without_associations
  end

  def tickets
    scope = if instance_options[:only_public]
              Api::V1::TicketsQuery.new(object.tickets).visible.published_state
            else
              TicketPolicy::Scope.new(current_user, object.tickets).resolve_by(object)
            end

    includes_options = instance_options[:authorize_attributes] || { answers: :attachments }
    scope = scope.includes(includes_options) unless object.tickets.any?(&:without_associations)

    scope
  end
end
