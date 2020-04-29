class TicketPolicy < ApplicationPolicy
  def update?
    if user.role? :service_responsible
      record_belongs_to_user?
    else
      user.role? :content_manager
    end
  end

  def destroy?
    user.role? :content_manager
  end

  def raise_rating?
    record.published_state?
  end

  def publish?
    user.role? :content_manager
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
      if (user.role?(:service_responsible) && scope_for_service_responsible?(service)) || user.one_of_roles?(:content_manager, :operator)
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
      elsif user.one_of_roles?(:content_manager, :operator)
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

  def attributes_for_show
    PolicyAttributes.new(
      serializer: Api::V1::Tickets::TicketResponsibleUserSerializer,
      serialize: ['correction', 'responsible_users', 'tags', 'answers.attachments,correction.*', 'correction.answers.attachments']
    )
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
