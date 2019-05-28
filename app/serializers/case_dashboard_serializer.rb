class CaseDashboardSerializer < ActiveModel::Serializer
  attributes :statuses

  has_many :cases, each_serializer: CaseSerializer
end
