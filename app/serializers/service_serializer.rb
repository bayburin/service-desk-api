class ServiceSerializer < ActiveModel::Serializer
  attributes :id, :category_id, :name, :short_description, :install, :is_hidden, :has_common_case, :popularity

  has_many :tickets, if: :include_associations?
  has_many :responsible_users, if: :include_associations?

  belongs_to :category, if: :include_associations?

  def include_associations?
    !object.without_associations
  end

  def tickets
    scope = Api::V1::TicketsQuery.new(object.tickets).visible.published_state

    if instance_options[:authorize_attributes]
      scope = scope.includes(*instance_options[:authorize_attributes]) unless object.tickets.any?(&:without_associations)
    else
      scope = scope.includes(answers: :attachments) unless object.tickets.any?(&:without_associations)
    end

    scope
  end
end
