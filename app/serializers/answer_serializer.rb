class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :ticket_id, :reason, :answer, :link, :is_hidden

  has_many :attachments, each_serializer: AnswerAttachmentSerializer

  belongs_to :ticket
end
