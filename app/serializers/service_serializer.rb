class ServiceSerializer < ActiveModel::Serializer
  attributes :id, :category_id, :name, :short_description, :install, :is_hidden, :has_common_case, :popularity

  has_many :tickets, if: :include_tickets?
  belongs_to :category, if: :include_category?

  def include_tickets?
    !object.without_associations
  end

  def include_category?
    !(object.without_associations || object.without_category)
  end
end
