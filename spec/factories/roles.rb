FactoryBot.define do
  factory :guest, class: Role do
    name { 'guest' }
    short_description { 'Гость' }
    long_description { 'Доступ только на чтение' }
  end
end
