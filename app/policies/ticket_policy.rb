class TicketPolicy < ApplicationPolicy
  def update?
    if user.role? :service_responsible
      record_belongs_to_user?
    else
      user.role? :content_manager
    end
  end

  def raise_rating?
    record.published_state?
  end

  # def show?
  #   if user.role? :service_responsible
  #     show_for_service_responsible?
  #   else
  #     show_for_guest?
  #   end
  # end

  # def create?
  #   if user.role? :service_responsible
  #     record.service.belongs_to?(user) || ticket_in_allowed_pool?
  #   else
  #     false
  #   end
  # end

  class Scope < Scope
    # метод вызывается из сервиса
    def resolve_by(service)
      if (user.role?(:service_responsible) && scope_for_service_responsible?(service)) || user.role?(:operator) || user.role?(:content_manager)
        Api::V1::TicketsQuery.new(scope).all.published_state
      else
        Api::V1::TicketsQuery.new(scope).visible.published_state
      end
    end

    protected

    def scope_for_service_responsible?(service)
      service.belongs_to?(user) || service.belongs_by_tickets_to?(user)
    end
  end

  class SphinxScope < Scope
    def resolve
      if user.role? :service_responsible
        scope.select { |ticket| allow_to_show_to_responsible?(ticket) }
      elsif user.role?(:operator) || user.role?(:content_manager)
        scope.select(&:published_state?)
      else
        scope.select { |ticket| ticket_not_hidden?(ticket) && ticket.published_state? }
      end
    end

    protected

    def allow_to_show_to_responsible?(ticket)
      ticket.published_state? && (ticket_not_hidden?(ticket) || ticket_belongs_to_user?(ticket) || ticket_in_allowed_pool?(ticket))
    end

    def ticket_belongs_to_user?(ticket)
      ticket.belongs_to?(user) || ticket.service.belongs_to?(user)
    end

    def ticket_not_hidden?(ticket)
      !ticket.service.is_hidden && !ticket.is_hidden
    end

    def ticket_in_allowed_pool?(ticket)
      ticket.service.belongs_by_tickets_to?(user)
    end
  end

  def attributes_for_search
    if user.role?(:service_responsible)
      PolicyAttributes.new(sql_include: [:responsible_users, service: :responsible_users])
    else
      PolicyAttributes.new(sql_include: [:service])
    end
  end

  def attributes_for_deep_search
    if user.role? :service_responsible
      PolicyAttributes.new(
        serializer: Api::V1::Tickets::TicketBaseSerializer,
        sql_include: [:responsible_users, service: :responsible_users, answers: :attachments]
      )
    elsif user.role?(:operator) || user.role?(:content_manager)
      PolicyAttributes.new(
        serializer: Api::V1::Tickets::TicketResponsibleUserSerializer,
        sql_include: [:service, answers: :attachments]
      )
    else
      PolicyAttributes.new(
        serializer: Api::V1::Tickets::TicketGuestSerializer,
        sql_include: [:service, answers: :attachments]
      )
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
