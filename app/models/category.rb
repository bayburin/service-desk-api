class Category < ApplicationRecord
  has_many :services, dependent: :destroy
  has_many :tickets, through: :services

  validates :name, presence: true

  attr_accessor :without_associations
end
