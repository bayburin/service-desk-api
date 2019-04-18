FactoryBot.define do
  factory :ticket do
    service { create(:service) }
    name { Faker::Restaurant.name }
    ticket_type { :question }
    is_hidden { false }
    to_approve { false }
    sla { 2 }
    popularity { Faker::Number.number(3) }
    responsible_users { build_list(:responsible_user, 2, responseable: nil) }
  end
end
