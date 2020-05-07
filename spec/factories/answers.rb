FactoryBot.define do
  factory :answer do
    question_ticket { build(:question_ticket, without_nested: true) }
    reason { Faker::Quotes::Shakespeare.as_you_like_it_quote }
    answer { Faker::Quotes::Shakespeare.romeo_and_juliet_quote }
    is_hidden { false }

    transient do
      without_nested { false }
    end

    after(:build) do |answer, ev|
      answer.attachments = build_list(:answer_attachment, 2, answer: answer) unless ev.without_nested
    end
  end
end
