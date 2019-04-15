Category.destroy_all
Tag.destroy_all

Category.create(
  [
    {
      name: 'Общие вопросы',
      short_description: 'Вопросы, касающиеся работы УИВТ',
      popularity: 20,
      icon_name: 'mdi-alert-decagram',
      services_attributes: [
        {
          name: 'Тестовая услуга',
          short_description: 'Техническая услуга, скрыть от всех',
          is_hidden: true,
          has_common_case: false,
          popularity: 7
        },
        {
          name: 'Кабинеты начальников',
          short_description: 'Здесь вы можете найти информацию о том, где находится начальник нужного вам отдела',
          is_hidden: false,
          has_common_case: false,
          popularity: 35
        },
        {
          name: 'Другое',
          short_description: 'Вопросы, не попадающие под все остальные категории',
          is_hidden: false,
          has_common_case: false,
          popularity: 64
        }
      ]
    },
    {
      name: 'Закрытая локальная сеть',
      popularity: 5,
      short_description: 'Вопросы, касающиеся закрытой локальной сети (ЗЛС)',
      icon_name: 'mdi-lan',
      services_attributes: [
        {
          name: 'Подключение к ЗЛС',
          short_description: 'Вопросы по подключению ЗЛС',
          is_hidden: false,
          has_common_case: true,
          popularity: 19
        },
        {
          name: 'Работа в ЗЛС',
          short_description: 'Вопросы по работе в ЗЛС',
          is_hidden: false,
          has_common_case: false,
          popularity: 11
        }
      ]
    }
  ]
)

Tag.create(
  [
    { name: 'сеть' },
    { name: 'локальная' },
    { name: 'закрытая' },
    { name: 'регистрация' },
    { name: 'отмена' },
    { name: 'разрегистрироваться' }
  ]
)

tickets = Ticket.create(
  [
    {
      service: Service.find_by(name: 'Подключение к ЗЛС'),
      name: 'Подключение к ЗЛС',
      ticket_type: :common_case,
      is_hidden: true,
      sla: '2 дня',
      popularity: 4
    },
    {
      service: Service.find_by(name: 'Подключение к ЗЛС'),
      name: 'Как зарегистрироваться в закрытой локальной сети?',
      ticket_type: :question,
      is_hidden: false,
      popularity: 33
    },
    {
      service: Service.find_by(name: 'Подключение к ЗЛС'),
      name: 'Как отменить регистрацию в закрытой локальной сети?',
      ticket_type: :question,
      is_hidden: false,
      popularity: 12
    }
  ]
)

tickets.first.tags << Tag.where(name: %w[сеть локальная закрытая регистрация])
tickets.last.tags << Tag.where(name: %w[сеть локальная закрытая отмена резрегистрироваться])

Ticket.find_by(name: 'Как зарегистрироваться в закрытой локальной сети?').answers.create(
  [
    {
      reason: 'В подразделении нет компьютера ЗЛС.',
      answer: 'Для того, чтобы получить компьютер ЗЛС для обработки информации, составляющей государственную тайну с грифом не выше "секретно", необходимо на имя нач. УИВТ Потуремского И.В. направить служебную записку с обоснованием необходимости установки данного компьютера (cosmos -> информация УИВТ -> бланки заявок - > заявка на регистрацию пользователя на сервере ЗЛС Общества).'
    },
    {
      reason: 'В подразделении есть компьютер ЗЛС.',
      answer: 'Заполнить заявку (cosmos -> информация УИВТ -> бланки заявок - > заявка на регистрацию пользователя на сервере ЗЛС Общества), согласовать её и принести в корп.2, ком.402б для получения ключа доступа и инструкции.'
    }
  ]
)