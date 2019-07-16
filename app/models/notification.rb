class Notification < ApplicationRecord
  has_many :readers, class_name: 'NotificationReader', foreign_key: :notification_id, dependent: :destroy

  enum event_type: { case: 1, broadcast: 2 }, _suffix: true
end