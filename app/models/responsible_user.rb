class ResponsibleUser < ApplicationRecord
  belongs_to :responseable, polymorphic: true

  validates :tn, presence: true
end
