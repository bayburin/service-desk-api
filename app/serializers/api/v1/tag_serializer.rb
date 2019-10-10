module Api
  module V1
    class TagSerializer < ActiveModel::Serializer
      attributes :id, :name
    end
  end
end
