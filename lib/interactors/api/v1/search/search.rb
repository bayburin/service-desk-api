module Api
  module V1
    module Search
      # Вызывает полнотекстовый поиск по категориям, услугам и тикетам
      class Search
        include Interactor::Organizer

        before do
          context.result = []
        end

        organize SearchCategories, SearchServices, SearchTickets
      end
    end
  end
end
