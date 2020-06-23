class Question < ApplicationRecord
  include Associatable

  has_many :answers, dependent: :destroy
  has_one :ticket, as: :ticketable, dependent: :destroy, inverse_of: :ticketable
  has_one :correction, class_name: 'Question', foreign_key: :original_id, dependent: :nullify

  belongs_to :original, class_name: 'Question', optional: true

  validates :answers, :ticket, presence: true, if: -> { ticket.published_state? }

  accepts_nested_attributes_for :answers, reject_if: proc { |attr| attr['answer'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :ticket, reject_if: proc { |attr| attr['name'].blank? }, allow_destroy: true

  delegate :service, to: :ticket
end
