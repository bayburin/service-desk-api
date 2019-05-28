class AnswerAttachment < ApplicationRecord
  mount_uploader :document, AnswerAttachmentUploader

  belongs_to :answer
end
