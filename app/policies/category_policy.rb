class CategoryPolicy < ApplicationPolicy
  def attributes_for_show
    if user.role?(:service_responsible) && belongs_to_user_by_service?
      PolicyAttributes.new(serializer: Api::V1::Categories::CategoryResponsibleUserSerializer)
    elsif user.one_of_roles?(:content_manager, :operator)
      PolicyAttributes.new(serializer: Api::V1::Categories::CategoryOperatorSerializer)
    else
      PolicyAttributes.new(serializer: Api::V1::Categories::CategoryGuestSerializer)
    end
  end

  protected

  def belongs_to_user_by_service?
    record.services.includes(:responsible_users).any? do |service|
      service.belongs_to?(user) || service.belongs_by_tickets_to?(user)
    end
  end
end
