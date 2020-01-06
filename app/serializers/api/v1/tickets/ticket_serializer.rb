module Api
  module V1
    module Tickets
      class TicketSerializer < TicketBaseSerializer
        has_many :responsible_users, if: :include_associations?, serializer: ResponsibleUserSerializer
        has_many :tags, if: :include_associations?
        has_one :correction, if: :include_associations?, serializer: TicketSerializer

        def answers
          AnswerPolicy::Scope.new(current_user, object.answers).resolve_by(object)
        end
      end
    end
  end
end
