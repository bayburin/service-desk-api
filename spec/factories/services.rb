FactoryBot.define do
  factory :service do
    category { build(:category, without_nested: true) }
    name { Faker::Restaurant.name }
    short_description { Faker::Restaurant.description }
    is_hidden { false }
    has_common_case { true }
    popularity { Faker::Number.number(3) }

    transient do
      without_nested { false }
    end

    after(:create) do |service, ev|
      create_list(:ticket, 2, service: service) unless ev.without_nested
    end
  end
end
