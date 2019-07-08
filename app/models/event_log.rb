class EventLog < ApplicationRecord
  has_many :readers, class_name: 'EventLogReader', foreign_key: :event_log_id, dependent: :destroy

  enum event_type: { case: 1, broadcast: 2 }, _suffix: true
end
