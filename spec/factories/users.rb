FactoryBot.define do
  factory :user do
    id_tn { Faker::Number.number(6) }
    tn { Faker::Number.number(6) }
    fio { 'Форточкина Клавдия Ивановна' }
    tel { '41-85' }
    dept { 714 }
    email { 'fortochkina' }
    details { { id: -110, emailText: 'bayburin@iss-reshetnev.ru' }.as_json }

    transient do
      role_name { :guest }
    end

    after(:build) do |user, ev|
      user.role = Role.find_by(name: ev.role_name) || create(ev.role_name.to_sym)
    end
  end

  factory :guest_user, parent: :user do
    after(:build) do |user, _ev|
      user.role = Role.find_by(name: :guest) || create(:guest)
    end
  end

  factory :service_responsible_user, parent: :user do
    after(:build) do |user, _ev|
      user.role = Role.find_by(name: :service_responsible) || create(:service_responsible)
    end
  end

  factory :operator_user, parent: :user do
    after(:build) do |user, _ev|
      user.role = Role.find_by(name: :operator) || create(:operator)
    end
  end

  factory :content_manager_user, parent: :user do
    after(:build) do |user, _ev|
      user.role = Role.find_by(name: :content_manager) || create(:content_manager)
    end
  end
end
