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

    after(:build) do |ticket, ev|
      ticket.ticketable = build(:question_ticket, ticket: ticket) unless ticket.ticketable
    end
  end
end
