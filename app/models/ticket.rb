class Ticket < ApplicationRecord
  is_impressionable counter_cache: true, column_name: :popularity, unique: :request_hash

  has_many :answers, dependent: :destroy
  has_many :ticket_tags, dependent: :destroy
  has_many :tags, through: :ticket_tags

  belongs_to :service

  validates :name, :ticket_type, presence: true
  validates :is_hidden, inclusion: { in: [true, false] }

  attr_accessor :without_associations, :without_service

  enum ticket_type: { question: 1, case: 2, common_case: 3 }
end
