class Service < ApplicationRecord
  is_impressionable counter_cache: true, column_name: :popularity, unique: :request_hash

  has_many :tickets, dependent: :destroy

  belongs_to :category

  validates :name, presence: true
  validates :is_sla, inclusion: { in: [true, false] }
end
