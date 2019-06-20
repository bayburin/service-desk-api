FactoryBot.define do
  factory :user_recommendation do
    title { Faker::Creature::Cat.name }
    link { Faker::Creature::Cat.name }
    order { Faker::Number.number(3) }
  end
end
