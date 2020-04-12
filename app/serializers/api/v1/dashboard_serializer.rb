module Api
  module V1
    class DashboardSerializer < ActiveModel::Serializer
      attributes :services

      has_many :categories, serializer: Categories::CategoryGuestSerializer
      has_many :user_recommendations, serializer: UserRecommendationSerializer

      def services
        ActiveModel::SerializableResource.new(object.services, each_serializer: Services::ServiceGuestSerializer, include: 'question_tickets.*')
      end
    end
  end
end
