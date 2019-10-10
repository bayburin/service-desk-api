module Api
  module V1
    class RoleSerializer < ActiveModel::Serializer
      attributes :id, :name, :short_description, :long_description
    end
  end
end
