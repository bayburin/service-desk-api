class Tag < ApplicationRecord
  has_many :ticket_tags, dependent: :destroy
  has_many :tickets, through: :ticket_tags

  after_create :set_ticket_delta_flag
  after_destroy :set_ticket_delta_flag

  protected

  def set_ticket_delta_flag
    tickets.update(delta: true)
  end
end
