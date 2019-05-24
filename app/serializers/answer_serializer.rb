class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :ticket_id, :reason, :answer, :link

  has_many :attachments, each_serializer: AnswerAttachmentSerializer

  belongs_to :ticket
end
