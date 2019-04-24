class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :short_description, :icon_name, :popularity

  has_many :services, if: :include_services?
  has_many :faq

  def faq
    object.tickets.where(ticket_type: :question).extend(Api::V1::Scope).by_popularity.includes(:answers).limit(5)
  end

  def include_services?
    !object.without_associations
  end
end
