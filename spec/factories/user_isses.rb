FactoryBot.define do
  factory :user_iss do
    id_tn { -110 }
    tn { 100_123 }
    fio { 'Форточкина Клавдия Ивановна' }
    tel { '41-85' }
    dept { 714 }
    email { 'fortochkina' }
  end
end
