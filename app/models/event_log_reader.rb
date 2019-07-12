class EventLogReader < ApplicationRecord
  belongs_to :user
  belongs_to :event_log
end
