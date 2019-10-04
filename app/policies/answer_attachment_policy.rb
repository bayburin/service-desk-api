class AnswerAttachmentPolicy < ApplicationPolicy
  def show?
    if user.role? :service_responsible
      true
    else
      record.ticket.published_state? && !record.ticket.is_hidden
    end
  end

  def create?
    TicketPolicy.new(user, record.ticket).update?
  end

  def destroy?
    TicketPolicy.new(user, record.ticket).update?
  end

  protected

  def ticket_belongs_to_user?
    record.ticket.belongs_to?(user) || record.service.belongs_to?(user)
  end
end
