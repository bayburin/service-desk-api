FactoryBot.define do
  factory :category do
    name { Faker::Restaurant.name }
    short_description { Faker::Restaurant.description }
    popularity { Faker::Number.number(3) }
  end
end
