module Messaging
  class CaseEventWorker
    include Sneakers::Worker
    include Api::V1::ActionCableBroadcast

    from_queue :case_event_receiver

    def work(msg)
      msg = JSON.parse(msg)
      Rails.logger.tagged('RabbitMQ') { Rails.logger.debug { "Получено сообщение: #{msg}" } }

      save_message(msg)
      ack!
    rescue StandardError => e
      Rails.logger.tagged('RabbitMQ') { Rails.logger.error { "CaseEventWorker. Получена ошибка: #{e.message}" } }
      reject!
    end

    private

    def save_message(msg)
      event = Notification.new(event_type: :case, tn: msg['user_tn'], body: msg)

      if event.save
        broadcast_notification_to_user(msg['user_tn'], event)
      else
        Rails.logger.tagged('RabbitMQ') { Rails.logger.error { "Ошибка при сохранении: #{event.errors.details.inspect}" } }
        raise 'Не удалось сохранить сообщение в БД'
      end
    end
  end
end
