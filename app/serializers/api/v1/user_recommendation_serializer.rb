module Api
  module V1
    class UserRecommendationSerializer < ActiveModel::Serializer
      attributes :id, :title, :external, :link, :query_params, :order
    end
  end
end
