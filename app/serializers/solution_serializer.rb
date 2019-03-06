class SolutionSerializer < ActiveModel::Serializer
  attributes :id, :ticket_id, :reason, :solution
end
