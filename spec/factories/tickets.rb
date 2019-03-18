FactoryBot.define do
  factory :ticket do
    service { create(:service) }
    name { Faker::Restaurant.name }
    popularity { Faker::Number.number(3) }
  end
end
