FactoryBot.define do
  factory :responsible_user do
    responseable { create(:ticket) }
    tn { Faker::Number.between(1, 30_000) }
  end
end
