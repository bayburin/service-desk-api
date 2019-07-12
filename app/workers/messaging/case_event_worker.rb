module Messaging
  class CaseEventWorker
    include Sneakers::Worker
    include Api::V1::ActionCableBroadcast

    from_queue :case_event_receiver

    def work(msg)
      msg = JSON.parse(msg)
      Rails.logger.tagged('RabbitMQ') { Rails.logger.debug { "Received message: #{msg}" } }

      save_message(msg)
      ack!
    rescue StandardError => e
      Rails.logger.tagged('RabbitMQ') { Rails.logger.error { "CaseEventWorker received error: #{e.message}" } }
      reject!
    end

    private

    def save_message(msg)
      if event = EventLog.create(event_type: :case, tn: msg['user_tn'], body: msg)
        broadcast_notification_to_user(msg['user_tn'], event)
      else
        raise 'Не удалось сохранить сообщение в БД'
      end
    end
  end
end
