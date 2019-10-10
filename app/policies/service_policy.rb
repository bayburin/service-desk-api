class ServicePolicy < ApplicationPolicy
  def show?
    if user.role? :service_responsible
      !record.is_hidden || belongs_to_user?
    else
      !record.is_hidden
    end
  end

  def tickets_ctrl_access?
    if user.role? :service_responsible
      belongs_to_user?
    else
      false
    end
  end

  class Scope < Scope
    def resolve
      if user.role? :service_responsible
        Api::V1::ServicesQuery.new(scope).search_by_responsible(user)
      else
        Api::V1::ServicesQuery.new(scope).visible
      end
    end
  end

  class SphinxScope < Scope
    def resolve
      if user.role? :service_responsible
        scope.select { |service| !service.is_hidden || service.belongs_to?(user) || service.belongs_by_tickets_to?(user) }
      else
        scope.reject(&:is_hidden)
      end
    end
  end

  def attributes_for_show
    if user.role?(:service_responsible) && belongs_to_user?
      PolicyAttributes.new(
        serializer: Api::V1::Services::ServiceResponsibleUserSerializer,
        sql_include: [:correction, :responsible_users, :tags, answers: :attachments],
        serialize: ['*', 'tickets.*', 'tickets.answers.attachments', 'tickets.correction.*', 'tickets.correction.answers.attachments']
      )
    else
      PolicyAttributes.new(
        serializer: Api::V1::Services::ServiceGuestSerializer,
        serialize: ['category', 'tickets.answers.attachments']
      )
    end
  end

  def attributes_for_search
    if user.role?(:service_responsible)
      PolicyAttributes.new(sql_include: [:responsible_users])
    else
      PolicyAttributes.new
    end
  end

  protected

  def belongs_to_user?
    record.belongs_to?(user) || record.belongs_by_tickets_to?(user)
  end
end
