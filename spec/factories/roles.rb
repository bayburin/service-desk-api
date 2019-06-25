FactoryBot.define do
  factory :guest, class: Role do
    name { 'guest' }
    short_description { 'Гость' }
    long_description { 'Доступ только на чтение открытых вопросов и подачу заявок' }
  end

  factory :operator, class: Role do
    name { 'operator' }
    short_description { 'Оператор' }
    long_description { 'Доступ ко всем вопросам на чтение' }
  end

  factory :content_manager, class: Role do
    name { 'content_manager' }
    short_description { 'Контент-менджер' }
    long_description { 'Доступ на редактирование и утверждение контента' }
  end

  factory :service_responsible, class: Role do
    name { 'service_responsible' }
    short_description { 'Ответственный за услугу' }
    long_description { 'Доступ на редактирование услуг, за которые пользователь отвечает' }
  end
end
