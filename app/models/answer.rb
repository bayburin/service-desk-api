class Answer < ApplicationRecord
  is_impressionable

  has_many :attachments, class_name: 'AnswerAttachment', dependent: :destroy

  belongs_to :ticket

  validates :ticket_id, :answer, presence: true
end
