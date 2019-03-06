class Ticket < ApplicationRecord
  has_many :solutions, dependent: :destroy
  has_many :ticket_tags, dependent: :destroy
  has_many :tags, through: :ticket_tags

  belongs_to :service

  validates :service_id, :ticket, presence: true
end
