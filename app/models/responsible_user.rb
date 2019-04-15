class ResponsibleUser < ApplicationRecord
  belongs_to :responseable, polymorphic: true
end
