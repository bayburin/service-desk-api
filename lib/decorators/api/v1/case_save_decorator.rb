module Api
  module V1
    # Класс оборачивает объект Case и дополняет параметрами, необходимыми для сохранения.
    class CaseSaveDecorator
      attr_reader :kase

      def initialize(kase)
        @kase = kase
      end

      def decorate
        processing_service
        processing_responsibles
        processing_files

        ::Rails.logger.debug { "Case after decorate: #{@kase.to_json}" }
      end

      protected

      def processing_service
        kase.ticket_id = find_ticket.try(:id)
        kase.sla = find_ticket.try(:sla)
      end

      def processing_responsibles
        kase.accs = find_ticket&.responsible_users&.pluck(:tn) || []
      end

      def find_ticket
        @find_ticket ||= kase.ticket_id ? Ticket.find(kase.ticket_id) : Ticket.find_by(ticket_type: :common_case, service_id: kase.service_id)
      end

      def processing_files
        kase.files.each do |file|
          file['file'] = file['file'].split(',')[1]
        end
      end
    end
  end
end
