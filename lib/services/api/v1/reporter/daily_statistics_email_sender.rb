module Api
  module V1
    module Reporter
      # Отправляет ежедневную статистику указанному пользователю по почте.
      class DailyStatisticsEmailSender < AbstractReporter
        def send(delivery_user, search_list, **params)
          ContentManagerMailer.search_daily_statistics_email(delivery_user, search_list, **params).deliver_now
        end
      end
    end
  end
end
