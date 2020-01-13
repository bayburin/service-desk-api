class ResponsibleUser < ApplicationRecord
  include Api::V1::UserDetailable

  belongs_to :responseable, polymorphic: true

  validates :tn, presence: true
end
