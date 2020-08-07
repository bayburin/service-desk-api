FactoryBot.define do
  factory :event, class: 'Ahoy::Event' do
    visit { create(:visit) }
    time { DateTime.now }
  end

  factory :search_event, parent: :event do
    name { Ahoy::Event::TYPES[:search] }
    sequence(:properties) { |i| "search string #{i}" }
  end

  factory :deep_search_event, parent: :event do
    name { Ahoy::Event::TYPES[:deep_search] }
    sequence(:properties) { |i| "deep search string #{i}" }
  end

  factory :action_event, parent: :event do
    name { Ahoy::Event::TYPES[:ran_action] }
    sequence(:properties) { |i| { action: "search string #{i}", controller: "some controller #{i}" } }
  end

  factory :search_result_event, parent: :event do
    name { Ahoy::Event::TYPES[:search_result] }
    sequence(:properties) { |i| { term: "search string #{i}", found: 5, found_services: 1, found_categories: 1, found_questions: 3 }.as_json }
  end

  factory :deep_search_result_event, parent: :event do
    name { Ahoy::Event::TYPES[:deep_search_result] }
    sequence(:properties) { |i| { term: "deep search string #{i}", found: 5, found_services: 1, found_categories: 1, found_questions: 3 }.as_json }
  end
end
