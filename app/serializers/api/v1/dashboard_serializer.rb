module Api
  module V1
    class DashboardSerializer < ActiveModel::Serializer
      attributes :services

      has_many :categories, serializer: Categories::CategoryGuestSerializer
      has_many :user_recommendations, serializer: UserRecommendationSerializer

      def services
        ActiveModelSerializers::SerializableResource.new(
          object.services, each_serializer: Services::ServiceGuestSerializer, include: 'questions.ticket'
        )
      end
    end
  end
end
