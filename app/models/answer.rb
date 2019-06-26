class Answer < ApplicationRecord
  has_many :attachments, class_name: 'AnswerAttachment', dependent: :destroy

  belongs_to :ticket

  validates :ticket_id, :answer, presence: true
  validates :is_hidden, inclusion: { in: [true, false] }
end
