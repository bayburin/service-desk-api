FactoryBot.define do
  factory :user do
    id_tn { -110 }
    tn { 100_123 }
    fio { 'Форточкина Клавдия Ивановна' }
    tel { '41-85' }
    dept { 714 }
    email { 'fortochkina' }

    transient do
      role_name { :guest }
    end

    after(:build) do |user, ev|
      user.role = Role.find_by(name: ev.role_name) || create(ev.role_name.to_sym)
    end
  end

  factory :guest_user, class: User do
    after(:build) do |user, _ev|
      user.role = Role.find_by(name: :guest) || create(:guest)
    end
  end

  factory :service_responsible_user, class: User do
    after(:build) do |user, _ev|
      user.role = Role.find_by(name: :service_responsible) || create(:service_responsible)
    end
  end
end
