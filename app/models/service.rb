class Service < ApplicationRecord
  include Associatable

  has_many :tickets, dependent: :destroy
  has_many :responsible_users, as: :responseable, dependent: :destroy

  belongs_to :category

  validates :name, presence: true
  validates :is_hidden, inclusion: { in: [true, false] }

  def calculate_popularity
    tickets.pluck(:popularity).reduce(:+)
  end

  def belongs_to?(user)
    responsible_users.map(&:tn).include?(user.tn)
  end

  def belongs_by_tickets_to?(user)
    tickets.includes(:responsible_users).any? { |ticket| ticket.belongs_to?(user) }
  end
end
