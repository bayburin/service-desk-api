FactoryBot.define do
  factory :notification_reader do
    user { create(:user) }
    tn { nil }
    notification { create(:notification) }
  end
end
