class Question < ApplicationRecord
  include Associatable
  include Belongable

  has_many :answers, dependent: :destroy
  has_one :ticket, as: :ticketable, dependent: :destroy, inverse_of: :ticketable
  has_one :correction, class_name: 'Question', foreign_key: :original_id, dependent: :nullify
  has_many :responsible_users, through: :ticket

  belongs_to :original, class_name: 'Question', optional: true

  accepts_nested_attributes_for :answers, allow_destroy: true
  accepts_nested_attributes_for :ticket, allow_destroy: true

  delegate :service, to: :ticket
end
