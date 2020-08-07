class AppTemplate < ApplicationRecord
  include Associatable
  include Belongable

  has_one :ticket, as: :ticketable, dependent: :destroy, inverse_of: :ticketable
end
