class Solution < ApplicationRecord
  is_impressionable

  belongs_to :ticket

  validates :ticket_id, :solution, presence: true
end
