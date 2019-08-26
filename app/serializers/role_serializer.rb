class RoleSerializer < ActiveModel::Serializer
  attributes :id, :name, :short_description, :long_description
end
