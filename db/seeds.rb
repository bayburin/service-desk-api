Category.destroy_all
Tag.destroy_all

Category.create(
  [
    {
      name: 'Общие вопросы',
      short_description: 'Вопросы, касающиеся работы УИВТ',
      services_attributes: [
        {
          name: 'Тестовая услуга',
          short_description: 'Техническая услуга, скрыть от всех',
          is_sla: false
        },
        {
          name: 'Кабинеты начальников',
          short_description: 'Здесь вы можете найти информацию о том, где находится начальник нужного вам отдела',
          is_sla: true
        },
        {
          name: 'Другое',
          short_description: 'Вопросы, не попадающие под все остальные категории',
          is_sla: true
        }
      ]
    },
    {
      name: 'Закрытая локальная сеть',
      short_description: 'Вопросы, касающиеся закрытой локальной сети (ЗЛС)',
      services_attributes: [
        {
          name: 'Подключение к ЗЛС',
          short_description: 'Вопросы по подключению ЗЛС',
          is_sla: true
        },
        {
          name: 'Работа в ЗЛС',
          short_description: 'Вопросы по работе в ЗЛС',
          is_sla: true
        }
      ]
    }
  ]
)

tags = Tag.create(
  [
    { name: 'сеть' },
    { name: 'локальная' },
    { name: 'закрытая' },
    { name: 'регистрация' }
  ]
)

ticket = Ticket.create(
  service: Service.find_by(name: 'Подключение к ЗЛС'),
  name: 'Как зарегистрироваться в закрытой локальной сети?'
)

ticket.tags << tags
