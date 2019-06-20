class DashboardSerializer < ActiveModel::Serializer
  has_many :categories, each_serializer: CategorySerializer
  has_many :services, each_serializer: ServiceSerializer
  has_many :user_recommendations, each_serializer: UserRecommendationSerializer
end
