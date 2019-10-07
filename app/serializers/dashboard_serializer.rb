class DashboardSerializer < ActiveModel::Serializer
  attributes :services

  has_many :categories, each_serializer: CategorySerializer
  has_many :user_recommendations, each_serializer: UserRecommendationSerializer

  def services
    ActiveModel::SerializableResource.new(object.services, each_serializer: ServiceSerializer, only_public: true, include: 'tickets')
  end
end
