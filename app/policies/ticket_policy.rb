class TicketPolicy < ApplicationPolicy
  def show?
    if user.role? :guest
      ticket_not_hidden?
    elsif user.role? :service_responsible
      ticket_not_hidden? ||
        record.belongs_to?(user) ||
        record.service.belongs_to?(user) ||
        ticket_in_allowed_pool?
    else
      true
    end
  end

  class Scope < Scope
    # метод вызывается из сервиса
    def resolve(service = nil)
      if user.role? :guest
        Api::V1::TicketsQuery.new(scope).visible
      elsif user.role? :service_responsible
        Api::V1::TicketsQuery.new(scope).all_in_service(service)
      else
        scope
      end
    end
  end

  class SphinxScope < Scope
    def resolve
      if user.role? :guest
        scope.select { |ticket| ticket_not_hidden?(ticket) }
      elsif user.role? :service_responsible
        scope.select do |ticket|
          ticket_not_hidden?(ticket) ||
            ticket.belongs_to?(user) ||
            ticket.service.belongs_to?(user) ||
            ticket_in_allowed_pool?(ticket, user)
        end
      else
        scope
      end
    end

    protected

    def ticket_not_hidden?(ticket)
      !ticket.service.is_hidden && !ticket.is_hidden
    end

    def ticket_in_allowed_pool?(ticket, user)
      ticket.service.belongs_by_tickets_to?(user)
    end
  end

  protected

  def ticket_not_hidden?
    !record.service.is_hidden && !record.is_hidden
  end

  def ticket_in_allowed_pool?
    record.service.belongs_by_tickets_to?(user)
  end
end
