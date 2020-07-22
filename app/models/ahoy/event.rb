class Ahoy::Event < ApplicationRecord
  include Ahoy::QueryMethods

  self.table_name = 'ahoy_events'

  belongs_to :visit
  belongs_to :user, optional: true

  # Типы событий
  TYPES = {
    # Был запущен метод контроллера
    ran_action: 'Ran action',
    # Был произведен поиск
    search: 'Search',
    # Был произведен поиск с более детальной выдачей информации
    deep_search: 'Deep search',
    # Был произведен поиск, сохранены результаты поиска
    search_result: 'Search result',
    # Был произведен поиск с более детальной выдачей информации, сохранены результаты поиска
    deep_search_result: 'Deep search result'
  }.freeze

  scope :ran_action, ->(**) { where(name: TYPES[:ran_action]) }
  scope :searched, ->(**) { where(name: TYPES[:search]) }
  scope :deep_search, ->(**) { where(name: TYPES[:deep_search]) }
  scope :search_result, ->(**) { where(name: TYPES[:search_result]) }
  scope :deep_search_result, ->(**) { where(name: TYPES[:deep_search_result]) }
end
