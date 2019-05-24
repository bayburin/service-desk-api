FactoryBot.define do
  factory :category do
    name { Faker::Restaurant.name }
    short_description { Faker::Restaurant.description }
    popularity { Faker::Number.number(3) }

    transient do
      without_nested { false }
    end

    after(:create) do |category, ev|
      create_list(:service, 2, category: category) unless ev.without_nested
    end
  end
end
