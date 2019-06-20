class Dashboard
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :categories, :services, :user_recommendations

  def initialize(categories, services, user_recommendations)
    @categories = categories
    @services = services
    @user_recommendations = user_recommendations
  end
end
