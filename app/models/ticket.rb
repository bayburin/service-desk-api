class Ticket < ApplicationRecord
  include Associatable
  include Belongable

  has_many :ticket_tags, dependent: :destroy
  has_many :tags, through: :ticket_tags
  has_many :responsible_users, as: :responseable, dependent: :destroy

  belongs_to :service
  belongs_to :ticketable, polymorphic: true, inverse_of: :ticket, optional: true

  validates :is_hidden, :to_approve, inclusion: { in: [true, false] }

  enum state: { draft: 1, published: 2 }, _suffix: true

  def self.generate_identity
    Ticket.maximum(:identity).to_i + 1
  end

  def generate_identity
    self.identity = Ticket.generate_identity
  end

  def calculate_popularity
    self.popularity += 1
  end

  def responsibles
    responsible_users.presence || service.responsible_users
  end
end
