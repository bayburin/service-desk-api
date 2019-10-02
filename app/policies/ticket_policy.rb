class TicketPolicy < ApplicationPolicy
  def show?
    if user.role? :service_responsible
      show_for_service_responsible?
    else
      show_for_guest?
    end
  end

  def create?
    if user.role? :service_responsible
      record.service.belongs_to?(user) || ticket_in_allowed_pool?
    else
      false
    end
  end

  # class Scope < Scope
  #   # метод вызывается из сервиса
  #   def resolve(service = nil)
  #     if user.role?(:service_responsible) && scope_for_service_responsible?(service)
  #       Api::V1::TicketsQuery.new(scope).all_in_service(service)
  #     else
  #       Api::V1::TicketsQuery.new(scope).visible.published_state
  #     end
  #   end

  #   protected

  #   def scope_for_service_responsible?(service)
  #     service.belongs_to?(user) || service.belongs_by_tickets_to?(user)
  #   end
  # end

  class SphinxScope < Scope
    def resolve
      if user.role? :service_responsible
        scope.select do |ticket|
          ticket.published_state? &&
            (ticket_not_hidden?(ticket) || ticket_belongs_to_user?(ticket, user) || ticket_in_allowed_pool?(ticket, user))
        end
      else
        scope.select { |ticket| ticket_not_hidden?(ticket) && ticket.published_state? }
      end
    end

    protected

    def ticket_belongs_to_user?(ticket, user)
      ticket.belongs_to?(user) || ticket.service.belongs_to?(user)
    end

    def ticket_not_hidden?(ticket)
      !ticket.service.is_hidden && !ticket.is_hidden
    end

    def ticket_in_allowed_pool?(ticket, user)
      ticket.service.belongs_by_tickets_to?(user)
    end
  end

  protected

  def show_for_guest?
    ticket_not_hidden? && record.published_state?
  end

  def show_for_service_responsible?
    show_for_guest? || record_belongs_to_user? || ticket_in_allowed_pool?
  end

  def record_belongs_to_user?
    record.belongs_to?(user) || record.service.belongs_to?(user)
  end

  def ticket_not_hidden?
    !record.service.is_hidden && !record.is_hidden
  end

  def ticket_in_allowed_pool?
    record.service.belongs_by_tickets_to?(user)
  end
end
