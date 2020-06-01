module Api
  module V1
    class AnswerSerializer < ActiveModel::Serializer
      attributes :id, :ticket_id, :reason, :answer, :link, :is_hidden

      has_many :attachments, serializer: AnswerAttachmentSerializer

      belongs_to :question
    end
  end
end
