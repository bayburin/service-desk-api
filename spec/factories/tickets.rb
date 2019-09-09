FactoryBot.define do
  factory :ticket do
    service { build(:service, without_nested: true) }
    name { Faker::Restaurant.name }
    ticket_type { :question }
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
      ticket.answers = build_list(:answer, 2, ticket: ticket) unless ev.without_nested
    end
  end
end
