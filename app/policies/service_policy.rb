class ServicePolicy < ApplicationPolicy
  def show?
    if user.role? :guest
      !record.is_hidden
    elsif user.role? :service_responsible
      !record.is_hidden || belongs_to_user?
    else
      true
    end
  end

  class Scope < Scope
    def resolve
      if user.role? :guest
        Api::V1::ServicesQuery.new(scope).visible
      elsif user.role? :service_responsible
        Api::V1::ServicesQuery.new(scope).search_by_responsible(user)
      else
        scope
      end
    end
  end

  class SphinxScope < Scope
    def resolve
      if user.role? :guest
        scope.reject(&:is_hidden)
      elsif user.role? :service_responsible
        scope.select { |service| !service.is_hidden || service.belongs_to?(user) || service.belongs_by_tickets_to?(user) }
      else
        scope
      end
    end
  end

  protected

  def belongs_to_user?
    record.belongs_to?(user) || record.belongs_by_tickets_to?(user)
  end
end
