# Для каждого контент-менеджера отправляет ежедневную статистику.
class SearchDailyStatisticsWorker
  include Sidekiq::Worker

  def perform
    date = Date.yesterday
    events = Api::V1::EventsQuery.new.all_search_by(date).pluck(:properties).uniq
    manager_ids = Api::V1::UsersQuery.new.managers.pluck(:id)

    manager_ids.each do |manager_id|
      SendDailyStatistics.perform_async(manager_id, events, date)
    end
  end
end
