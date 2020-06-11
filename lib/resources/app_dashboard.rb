class AppDashboard
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :apps, :statuses

  def initialize(args = {})
    @apps = args['cases']
    @statuses = args['statuses']
  end
end
