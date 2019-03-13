class Ticket < ApplicationRecord
  is_impressionable counter_cache: true, column_name: :popularity, unique: :request_hash

  has_many :solutions, dependent: :destroy
  has_many :ticket_tags, dependent: :destroy
  has_many :tags, through: :ticket_tags

  belongs_to :service

  validates :service_id, :ticket, presence: true
end
