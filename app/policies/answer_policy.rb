class AnswerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve_by(ticket)
      if user.role?(:service_responsible) && scope_for_service_responsible?(ticket)
        scope
      else
        scope.extend(Api::V1::Scope).visible
      end
    end

    protected

    def scope_for_service_responsible?(ticket)
      ticket_belongs_to_user?(ticket) || ticket_in_allowed_pool?(ticket)
    end

    def ticket_belongs_to_user?(ticket)
      ticket.belongs_to?(user) || ticket.service.belongs_to?(user)
    end

    def ticket_in_allowed_pool?(ticket)
      ticket.service.belongs_by_tickets_to?(user)
    end
  end
end
