FactoryBot.define do
  factory :user do
    id_tn { -110 }
    tn { 100_123 }
    fio { 'Форточкина Клавдия Ивановна' }
    tel { '41-85' }
    dept { 714 }
    email { 'fortochkina' }

    after(:build) do |user, ev|
      unless ev.role
        user.role = Role.find_by(name: :guest) || create(:guest)
      end
    end
  end
end
