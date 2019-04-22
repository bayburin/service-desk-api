class CaseDashboard
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :cases, :statuses

  def initialize(args = {})
    @cases = args['cases']
    @statuses = args['statuses']
  end
end
