FactoryBot.define do
  factory :ticket do
    service { create(:service) }
    name { Faker::Restaurant.name }
    ticket_type { :question }
    is_hidden { false }
    sla { '20 minutes' }
    popularity { Faker::Number.number(3) }
  end
end
