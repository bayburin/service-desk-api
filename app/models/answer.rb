class Answer < ApplicationRecord
  has_many :attachments, class_name: 'AnswerAttachment', dependent: :destroy

  belongs_to :question

  validates :is_hidden, inclusion: { in: [true, false] }

  delegate :ticket, to: :question
end
