class Dashboard
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :categories, :services

  def initialize(categories, services)
    @categories = categories
    @services = services
  end
end
