class UserOwnsSerializer < ActiveModel::Serializer
  has_many :items
  has_many :services, each_serializer: ServiceSerializer
end
