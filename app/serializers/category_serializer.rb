class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :short_description, :popularity

  has_many :services
end
