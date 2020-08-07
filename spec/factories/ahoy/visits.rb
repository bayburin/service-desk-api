FactoryBot.define do
  factory :visit, class: 'Ahoy::Visit' do
    visit_token { nil }
    visitor_token { nil }
  end
end
