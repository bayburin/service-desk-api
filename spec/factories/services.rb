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
      # create_list(:question_ticket, 2, service: service) unless ev.without_nested
      unless ev.without_nested
        2.times do
          ticket = build(:ticket, service: service)
          create(:question_ticket, ticket: ticket)
        end
      end
    end
  end
end
