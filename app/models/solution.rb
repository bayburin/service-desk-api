class Solution < ApplicationRecord
  belongs_to :ticket

  validates :ticket_id, :solution, presence: true
end
