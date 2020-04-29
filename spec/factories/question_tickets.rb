FactoryBot.define do
  factory :question_ticket do
    transient do
      without_nested { false }
      name { '' }
      state { :published }
      is_hidden { false }
    end

    after(:build) do |question, ev|
      question.answers = build_list(:answer, 2, question_ticket: question) unless ev.without_nested
      question.ticket = build(:ticket, without_nested: true, name: ev.name, state: ev.state, is_hidden: ev.is_hidden) unless question.ticket
    end
  end
end
