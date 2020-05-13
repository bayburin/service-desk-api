class Answer < ApplicationRecord
  has_many :attachments, class_name: 'AnswerAttachment', dependent: :destroy

  belongs_to :question_ticket

  validates :question_ticket, :answer, presence: true
  validates :is_hidden, inclusion: { in: [true, false] }

  accepts_nested_attributes_for :attachments

  delegate :ticket, to: :question_ticket
end
