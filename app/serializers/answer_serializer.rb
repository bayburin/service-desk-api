class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :ticket_id, :reason, :answer, :link

  belongs_to :ticket
end
