class TicketSerializer < ActiveModel::Serializer
  attributes :id, :service_id, :name, :ticket_type, :state, :is_hidden, :sla, :popularity

  has_many :answers, if: :include_associations?
  has_many :responsible_users, if: :include_associations?
  has_many :tags, if: :include_associations?
  has_one :correction, if: :include_associations?, serializer: TicketSerializer

  belongs_to :service

  def include_associations?
    !object.without_associations
  end

  def answers
    AnswerPolicy::Scope.new(current_user, object.answers).resolve_by(object)
  end
end
