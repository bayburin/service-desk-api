class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :short_description, :popularity

  has_many :services, if: :include_services?

  def include_services?
    !object.without_associations
  end
end
