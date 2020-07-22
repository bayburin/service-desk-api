FactoryBot.define do
  factory :event, class: 'Ahoy::Event' do
    visit { create(:visit) }
    time { DateTime.now }
  end

  factory :search_event, parent: :event do
    name { 'Search' }
    sequence(:properties) { |i| "search string #{i}" }
  end

  factory :deep_search_event, parent: :event do
    name { 'Deep Search' }
    sequence(:properties) { |i| "deep search string #{i}" }
  end

  factory :action_event, parent: :event do
    name { 'Ran action' }
    sequence(:properties) { |i| { action: "search string #{i}", controller: "some controller #{i}" } }
  end
end
