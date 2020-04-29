FactoryBot.define do
  factory :case do
    case_id { nil }
    user_tn { nil }
    id_tn { nil }
    # dept { nil }
    # fio { nil }
    phone { nil }
    email { nil }
    user_info { nil }
    status_id { nil }
    status { nil }
    starttime { nil }
    endtime { nil }
    time { nil }
    service_id { service.try(:id) }
    service { nil }
    ticket_id { Ticket.where(service_id: service_id, ticketable_type: %i[CaseTicket CommonCaseTicket]).first.try(:id) }
    ticket { nil }
    host_id { 765_300 }
    item_id { 123 }
    desc { Faker::Quote.famous_last_words }
    mobile { Faker::PhoneNumber.phone_number }
    without_service { false }
    without_item { false }
    sla { nil }
    accs { [] }
    files { [] }

    initialize_with { new(attributes) }

    transient do
      user { build(:user) }
    end

    after(:build) do |kase, ev|
      user = ev.user || build(:user)
      kase.user_tn = user.tn
      kase.id_tn = user.id_tn
      # kase.dept = user.dept
      # kase.fio = user.fio
      kase.phone = user.tel
      kase.email = user.email

      kase.service_id ||= ev.service&.id
    end
  end
end


