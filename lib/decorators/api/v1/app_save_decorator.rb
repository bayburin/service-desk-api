module Api
  module V1
    # Класс оборачивает объект App и дополняет параметрами, необходимыми для сохранения.
    class AppSaveDecorator
      attr_reader :app

      def initialize(app)
        @app = app
      end

      def decorate
        processing_service
        processing_responsibles
        processing_files

        ::Rails.logger.debug { "Application after decorate: #{@app.to_json}" }
      end

      protected

      def processing_service
        app.ticket_id = find_ticket.try(:id)
        app.sla = find_ticket.try(:sla)
      end

      def processing_responsibles
        app.accs = find_ticket ? find_ticket.responsibles.pluck(:tn) : []
      end

      def find_ticket
        @find_ticket ||= app.ticket_id ? Ticket.find(app.ticket_id) : Ticket.find_by(ticketable_type: :FreeApplication, service_id: app.service_id)
      end

      def processing_files
        app.files.each do |file|
          file['file'] = file['file'].split(',')[1]
        end
      end
    end
  end
end
