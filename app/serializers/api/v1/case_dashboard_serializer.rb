module Api
  module V1
    class CaseDashboardSerializer < ActiveModel::Serializer
      attributes :statuses

      has_many :cases, serializer: CaseSerializer
    end
  end
end
