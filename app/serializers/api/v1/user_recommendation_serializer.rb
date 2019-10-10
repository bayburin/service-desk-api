module Api
  module V1
    class UserRecommendationSerializer < ActiveModel::Serializer
      attributes :id, :title, :link, :order
    end
  end
end
