class AppTemplate < ApplicationRecord
  include Associatable
  include Belongable

  has_one :ticket, as: :ticketable, dependent: :destroy, inverse_of: :ticketable
  has_many :works, class_name: 'Template::Work', dependent: :destroy
end
