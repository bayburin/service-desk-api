# Вызывает методы, реализующие отправку ежедневной статистики указанным контент-менеджерам разными способами (email, xmpp и т.д.).
class SendDailyStatistics
  include Sidekiq::Worker

  def perform(user_id, search_list, date)
    delivery_user = User.find(user_id).load_details

    Api::V1::ReportSender.new(delivery_user, search_list, date: date).send_report(Api::V1::Reporter::DailyStatisticsEmailSender.new)
  end
end
