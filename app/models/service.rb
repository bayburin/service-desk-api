class Service < ApplicationRecord
  is_impressionable counter_cache: true, column_name: :popularity, unique: :request_hash

  has_many :tickets, dependent: :destroy

  belongs_to :category

  validates :name, presence: true
  validates :is_hidden, inclusion: { in: [true, false] }

  attr_accessor :without_associations, :without_category

  scope :by_popularity, -> { order('popularity DESC') }
end
