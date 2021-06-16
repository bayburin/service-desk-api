module Api
  module V2
    class ServiceOrbitaSerializer < ActiveModel::Serializer
      attributes :id, :name
    end
  end
end
