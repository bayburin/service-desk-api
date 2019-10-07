class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :short_description, :icon_name, :popularity

  has_many :services, if: :include_associations?
  has_many :faq, if: :include_associations?

  def faq
    Api::V1::QuestionsQuery.new(object.tickets).most_popular.includes(:responsible_users, service: :responsible_users)
  end

  def include_associations?
    !object.without_associations
  end

  def services
    ServicePolicy::Scope.new(current_user, object.services).resolve
  end
end
