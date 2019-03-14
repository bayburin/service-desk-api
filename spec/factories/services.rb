FactoryBot.define do
  factory :service do
    category { create(:category) }
    name { Faker::Restaurant.name }
    short_description { Faker::Restaurant.description }
    is_sla { true }
    popularity { Faker::Number.number(3) }
  end
end
