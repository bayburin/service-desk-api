FactoryBot.define do
  factory :question_ticket do
    ticket { build(:ticket, without_nested: true) }

    transient do
      without_nested { false }
    end

    after(:build) do |ticket, ev|
      ticket.answers = build_list(:answer, 2, question_ticket: ticket) unless ev.without_nested
    end
  end
end
