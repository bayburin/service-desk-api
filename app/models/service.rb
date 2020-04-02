class Service < ApplicationRecord
  include Associatable
  include Belongable

  has_many :tickets, dependent: :destroy
  has_many :question_tickets, through: :tickets, source: :ticketable, source_type: 'QuestionTicket'
  has_many :responsible_users, as: :responseable, dependent: :destroy

  belongs_to :category

  validates :name, presence: true
  validates :is_hidden, inclusion: { in: [true, false] }

  def calculate_popularity
    tickets.pluck(:popularity).reduce(:+)
  end

  def belongs_by_tickets_to?(user)
    tickets.includes(:responsible_users).any? { |ticket| ticket.belongs_to?(user) }
  end
end
