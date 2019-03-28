class Answer < ApplicationRecord
  is_impressionable

  belongs_to :ticket

  validates :ticket_id, :answer, presence: true
end
