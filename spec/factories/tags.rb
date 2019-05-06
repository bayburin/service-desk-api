FactoryBot.define do
  factory :tag do
    name { Faker::Creature::Cat.name }
  end
end
