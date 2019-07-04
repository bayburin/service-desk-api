module Messaging
  class CaseEventWorker
    include Sneakers::Worker

    from_queue :case_event_receiver

    def work(msg)
      msg = JSON.parse(msg)
      Rails.logger.tagged('RabbitMQ') { Rails.logger.debug { "Received message: #{msg}" } }

      # TODO: Записать в базу и отправить сообщение пользователю
      # ActionCable.server.broadcast "case/current_user_#{msg['user_tn']}", message: msg['message']
      ack!
    rescue StandardError => e
      Rails.logger.tagged('RabbitMQ') { Rails.logger.error { "CaseEventWorker received error: #{e.message}" } }
      reject!
    end
  end
end
