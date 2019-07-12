FactoryBot.define do
  factory :event_log_reader do
    user { create(:user) }
    tn { nil }
    event_log { create(:event_log) }
  end
end
