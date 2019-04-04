class UserOwns
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :items, :services

  def initialize(items, services)
    @items = items
    @services = services
  end
end