class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :event_type, :tn, :body, :date

  def date
    object.created_at.strftime('%d.%m.%Y %H:%M')
  end
end
