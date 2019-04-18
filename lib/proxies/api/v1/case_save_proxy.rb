module Api
  module V1
    # Класс оборачивает объект Case и дополняет параметрами, необходимыми для сохранения.
    class CaseSaveProxy
      attr_reader :kase

      def initialize(kase)
        @kase = kase
      end

      def method_missing(method_name, *args)
        if need_to_respond?(method_name)
          process_params
          kase.send(method_name, *args)
        else
          super
        end
      end

      def respond_to_missing?(method_name, *args)
        need_to_respond?(method_name) || super
      end

      protected

      def need_to_respond?(method_name)
        method_name.to_s == 'save'
      end

      def process_params
        processing_service
        processing_responsibles

        ::Rails.logger.debug "Case after processing: #{kase.to_json}"
      end

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
    end
  end
end
