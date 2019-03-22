Category.destroy_all
Tag.destroy_all

Category.create(
  [
    {
      name: 'Общие вопросы',
      short_description: 'Вопросы, касающиеся работы УИВТ',
      popularity: 20,
      services_attributes: [
        {
          name: 'Тестовая услуга',
          short_description: 'Техническая услуга, скрыть от всех',
          is_sla: false,
          popularity: 7
        },
        {
          name: 'Кабинеты начальников',
          short_description: 'Здесь вы можете найти информацию о том, где находится начальник нужного вам отдела',
          is_sla: true,
          popularity: 35
        },
        {
          name: 'Другое',
          short_description: 'Вопросы, не попадающие под все остальные категории',
          is_sla: true,
          popularity: 64
        }
      ]
    },
    {
      name: 'Закрытая локальная сеть',
      popularity: 5,
      short_description: 'Вопросы, касающиеся закрытой локальной сети (ЗЛС)',
      services_attributes: [
        {
          name: 'Подключение к ЗЛС',
          short_description: 'Вопросы по подключению ЗЛС',
          is_sla: true,
          popularity: 19
        },
        {
          name: 'Работа в ЗЛС',
          short_description: 'Вопросы по работе в ЗЛС',
          is_sla: true,
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
      name: 'Как зарегистрироваться в закрытой локальной сети?',
      popularity: '33'
    },
    {
      service: Service.find_by(name: 'Подключение к ЗЛС'),
      name: 'Как отменить регистрацию в закрытой локальной сети?',
      popularity: '12'
    }
  ]
)

tickets.first.tags << Tag.where(name: %w[сеть локальная закрытая регистрация])
tickets.last.tags << Tag.where(name: %w[сеть локальная закрытая отмена резрегистрироваться])
