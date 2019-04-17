class Category < ApplicationRecord
  has_many :services, dependent: :destroy

  validates :name, presence: true

  attr_accessor :without_associations
end
