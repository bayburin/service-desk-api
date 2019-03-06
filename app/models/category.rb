class Category < ApplicationRecord
  has_many :services, dependent: :destroy

  validates :name, presence: true

  accepts_nested_attributes_for :services
end
