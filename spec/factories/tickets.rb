FactoryBot.define do
  factory :ticket do
    sequence(:identity) { |i| i }
    service { build(:service, without_nested: true) }
    name { Faker::Restaurant.name }
    state { :published }
    is_hidden { false }
    to_approve { false }
    sla { 2 }
    popularity { Faker::Number.number(3) }
    # responsible_users { build_list(:responsible_user, 2, responseable: nil) }

    transient do
      without_nested { false }
    end

    trait :question do
      after(:build) do |ticket, ev|
        ticket.ticketable = build(:question, ticket: ticket) unless ticket.ticketable
      end
    end

    trait :common_case do
      after(:build) do |ticket, ev|
        ticket.ticketable_type = 'FreeApplication' unless ticket.ticketable
      end
    end

    # FIXME: Исправить после создания таблицы заявок
    trait :app do
      after(:build) do |ticket, ev|
        ticket.ticketable_type = 'Application' unless ticket.ticketable
      end
    end
  end
end
