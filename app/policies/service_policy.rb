class ServicePolicy < ApplicationPolicy
  def show?
    if user.role? :service_responsible
      !record.is_hidden || belongs_to_user?
    elsif user.one_of_roles?(:content_manager, :operator)
      true
    else
      !record.is_hidden
    end
  end

  def tickets_ctrl_access?
    if user.role? :service_responsible
      belongs_to_user?
    else
      user.role? :content_manager
    end
  end

  class Scope < Scope
    def resolve
      if user.role? :service_responsible
        Api::V1::ServicesQuery.new(scope).search_by_responsible(user)
      elsif user.one_of_roles?(:content_manager, :operator)
        Api::V1::ServicesQuery.new(scope).all
      else
        Api::V1::ServicesQuery.new(scope).visible
      end
    end
  end

  class SphinxScope < Scope
    def resolve
      if user.role? :service_responsible
        scope.select { |service| !service.is_hidden || service.belongs_to?(user) || service.belongs_by_tickets_to?(user) }
      elsif user.one_of_roles?(:content_manager, :operator)
        scope
      else
        scope.reject(&:is_hidden)
      end
    end
  end

  def attributes_for_index
    if user.role? :service_responsible
      PolicyAttributes.new(
        serializer: Api::V1::Services::ServiceBaseSerializer,
        sql_include: [:category, :responsible_users, tickets: %i[answers responsible_users]]
      )
    elsif user.one_of_roles?(:content_manager, :operator)
      PolicyAttributes.new(
        serializer: Api::V1::Services::ServiceResponsibleUserSerializer,
        sql_include: [:category, tickets: :answers]
      )
    else
      PolicyAttributes.new(
        serializer: Api::V1::Services::ServiceGuestSerializer,
        sql_include: [:category, tickets: :answers]
      )
    end
  end

  def attributes_for_show
    if user.role?(:service_responsible) && belongs_to_user? || user.role?(:content_manager)
      PolicyAttributes.new(
        serializer: Api::V1::Services::ServiceResponsibleUserSerializer,
        sql_include: [
          ticket: %i[responsible_users tags service],
          answers: :attachments,
          correction: [ticket: %i[responsible_users tags service], answers: :attachments]
        ],
        serialize: [
          '*', 'questions.ticket.service', 'questions.ticket.*', 'questions.answers.attachments', 'questions.correction.*',
          'questions.correction.answers.attachments', 'questions.correction.ticket.responsible_users',
          'questions.correction.ticket.tags'
        ]
      )
    elsif user.role?(:operator)
      PolicyAttributes.new(
        serializer: Api::V1::Services::ServiceResponsibleUserSerializer,
        sql_include: [ticket: %i[service responsible_users]],
        serialize: ['category', 'questions.ticket.service', 'questions.answers.attachments', 'questions.ticket.responsible_users', 'questions.ticket.service']
      )
    else
      PolicyAttributes.new(
        serializer: Api::V1::Services::ServiceGuestSerializer,
        sql_include: [ticket: :service],
        serialize: ['category', 'questions.ticket.service', 'questions.answers.attachments', 'questions.*']
      )
    end
  end

  def attributes_for_search
    if user.role? :service_responsible
      PolicyAttributes.new(
        sql_include: [:responsible_users],
        serialize: ['responsible_users']
      )
    else
      PolicyAttributes.new
    end
  end

  protected

  def belongs_to_user?
    record.belongs_to?(user) || record.belongs_by_tickets_to?(user)
  end
end
