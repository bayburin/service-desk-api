module Api
  module V1
    module TicketScope
      include Scope

      # Показать опубликованные тикеты.
      def published
        where(state: :published)
      end

      # Показать тикеты только если они принадлежат видимым услугам.
      def by_visible_service
        joins(:service).where(services: { is_hidden: false })
      end
    end
  end
end
