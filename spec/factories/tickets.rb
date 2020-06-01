FactoryBot.define do
  factory :ticket do
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
        ticket.ticketable_type = 'CommonCaseTicket' unless ticket.ticketable
      end
    end

    # FIXME: Исправить после создания таблицы заявок
    trait :case do
      after(:build) do |ticket, ev|
        ticket.ticketable_type = 'CaseTicket' unless ticket.ticketable
      end
    end
  end
end
