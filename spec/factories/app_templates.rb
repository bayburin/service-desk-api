FactoryBot.define do
  factory :app_template do
    transient do
      without_nested { false }
      name { Faker::Restaurant.name }
      state { :published }
      is_hidden { false }
      sequence(:popularity) { |i| i }
    end

    after(:build) do |template, ev|
      template.ticket = build(:ticket, name: ev.name, state: ev.state, is_hidden: ev.is_hidden, popularity: ev.popularity) unless template.ticket
    end
  end
end
