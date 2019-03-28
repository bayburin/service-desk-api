FactoryBot.define do
  factory :answer do
    ticket { create(:ticket) }
    reason { Faker::Quotes::Shakespeare.as_you_like_it_quote }
    answer { Faker::Quotes::Shakespeare.romeo_and_juliet_quote }
  end
end
