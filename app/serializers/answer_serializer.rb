class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :ticket_id, :reason, :answer
end
