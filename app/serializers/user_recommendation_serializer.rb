class UserRecommendationSerializer < ActiveModel::Serializer
  attributes :id, :title, :link, :order
end
