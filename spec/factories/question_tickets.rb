FactoryBot.define do
  factory :question_ticket do
    transient do
      without_nested { false }
      name { Faker::Restaurant.name }
      state { :published }
      is_hidden { false }
      sequence(:popularity) { |i| i }
    end

    after(:build) do |question, ev|
      question.answers = build_list(:answer, 2, question_ticket: question) unless ev.without_nested
      question.ticket = build(:ticket, name: ev.name, state: ev.state, is_hidden: ev.is_hidden, popularity: ev.popularity) unless question.ticket
    end
  end
end
