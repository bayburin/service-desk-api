class CaseDashboardSerializer < ActiveModel::Serializer
  attributes :statuses, :case_count

  has_many :cases, each_serializer: CaseSerializer
end
