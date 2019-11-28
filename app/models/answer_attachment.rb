class AnswerAttachment < ApplicationRecord
  mount_uploader :document, AnswerAttachmentUploader

  belongs_to :answer

  delegate :ticket, to: :answer
  delegate :service, to: :ticket
end
