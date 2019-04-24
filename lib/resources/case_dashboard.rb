class CaseDashboard
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :cases, :statuses, :case_count

  def initialize(args = {})
    @cases = args['cases']
    @statuses = args['statuses']
    @case_count = args['case_count']
  end
end
