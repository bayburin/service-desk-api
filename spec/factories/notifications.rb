FactoryBot.define do
  factory :notification do
    event_type { :case }
    body { { user_tn: 17_664, message: 'Test' }.as_json }
  end
end
