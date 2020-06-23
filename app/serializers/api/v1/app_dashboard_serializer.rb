module Api
  module V1
    class AppDashboardSerializer < ActiveModel::Serializer
      attributes :statuses

      has_many :apps, serializer: AppSerializer
    end
  end
end
