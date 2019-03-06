class Service < ApplicationRecord
  has_many :tickets, dependent: :destroy

  belongs_to :category

  validates :name, presence: true
  validates :is_sla, inclusion: { in: [true, false] }
end
