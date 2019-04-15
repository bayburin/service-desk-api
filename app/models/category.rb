class Category < ApplicationRecord
  is_impressionable counter_cache: true, column_name: :popularity, unique: :request_hash

  has_many :services, dependent: :destroy

  validates :name, presence: true

  attr_accessor :without_associations
end
