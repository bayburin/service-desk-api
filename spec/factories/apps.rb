FactoryBot.define do
  factory :app do
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
    ticket_id { Ticket.where(service_id: service_id, ticketable_type: %i[Application FreeApplication]).first.try(:id) }
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

    after(:build) do |app, ev|
      user = ev.user || build(:user)
      app.user_tn = user.tn
      app.id_tn = user.id_tn
      # app.dept = user.dept
      # app.fio = user.fio
      app.phone = user.tel
      app.email = user.email

      app.service_id ||= ev.service&.id
    end
  end
end


