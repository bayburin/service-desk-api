class Category < ApplicationRecord
  include Associatable

  has_many :services, dependent: :destroy
  has_many :questions, through: :services

  validates :name, presence: true

  def calculate_popularity
    services.pluck(:popularity).reduce(:+)
  end
end
