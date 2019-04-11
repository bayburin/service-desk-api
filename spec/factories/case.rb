FactoryBot.define do
  factory :case do
    case_id { nil }
    service { create(:service) }
    ticket_id { service.tickets.where(ticket_type: %i[case common_case]).first.try(:id) }
    host_id { 765_300 }
    item_id { 123 }
    desc { Faker::Quote.famous_last_words }
    mobile { Faker::PhoneNumber.phone_number }
    without_service { false }
    without_item { false }

    transient do
      user_iss { build_stubbed(:user_iss) }
    end

    after(:build) do |kase, ev|
      user = ev.user_iss || build_stubbed(:user_iss)
      kase.user_tn = user.tn
      kase.id_tn = user.id_tn
      kase.dept = user.dept
      kase.fio = user.fio
      kase.phone = user.tel
      kase.email = user.email
    end
  end
end
