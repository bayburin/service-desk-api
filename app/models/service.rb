class Service < ApplicationRecord
  has_many :tickets, dependent: :destroy
  has_many :responsible_users, as: :responseable, dependent: :destroy

  belongs_to :category

  validates :name, presence: true
  validates :is_hidden, inclusion: { in: [true, false] }

  attr_accessor :without_associations
end
