class NotificationReader < ApplicationRecord
  belongs_to :user
  belongs_to :notification

  validates :tn, presence: true, uniqueness: { scope: :notification_id }
end
