module Api
  module V1
    module TicketScope
      include Scope

      # Сортировка по популярности
      def by_popularity
        order('tickets.popularity DESC')
      end

      # Показать опубликованные тикеты.
      def published
        where(tickets: { state: :published })
      end

      # Показать черновые тикеты.
      def draft
        where(tickets: { state: :draft })
      end

      # Показать видимые объекты
      def visible
        where(tickets: { is_hidden: false })
      end

      # Показать тикеты только если они принадлежат видимым услугам.
      def by_visible_service
        joins(ticket: :service).where(services: { is_hidden: false })
      end
    end
  end
end
