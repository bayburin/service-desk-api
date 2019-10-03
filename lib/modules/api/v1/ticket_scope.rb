module Api
  module V1
    module TicketScope
      include Scope

      # Показать опубликованные объекты
      def published
        where(state: :published)
      end
    end
  end
end
