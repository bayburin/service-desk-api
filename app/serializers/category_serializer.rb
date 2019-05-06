class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :short_description, :icon_name, :popularity

  has_many :services, if: :include_services?
  has_many :faq, if: :include_faqs?

  def faq
    Api::V1::QuestionsQuery.new(object.tickets).most_popular
  end

  def include_services?
    !object.without_associations
  end

  def include_faqs?
    !object.without_associations
  end
end
