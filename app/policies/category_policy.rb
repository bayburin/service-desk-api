class CategoryPolicy < ApplicationPolicy
  def attributes_for_show
    if user.role?(:service_responsible) && belongs_to_user_by_service?
      {
        serializer: Api::V1::Categories::CategoryResponsibleUserSerializer,
        include: [],
        serialize: ['services', 'faq.answers.attachments']
      }
    else
      {
        serializer: Api::V1::Categories::CategoryGuestSerializer,
        include: [],
        serialize: ['services', 'faq.answers.attachments']
      }
    end
  end

  protected

  def belongs_to_user_by_service?
    record.services.includes(:responsible_users).any? do |service|
      service.belongs_to?(user) || service.belongs_by_tickets_to?(user)
    end
  end
end
