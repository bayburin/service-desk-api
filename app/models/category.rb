class Category < ApplicationRecord
  include Associatable

  has_many :services, dependent: :destroy
  has_many :question_tickets, through: :services

  validates :name, presence: true

  def calculate_popularity
    services.pluck(:popularity).reduce(:+)
  end
end
