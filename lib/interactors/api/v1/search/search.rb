module Api
  module V1
    module Search
      # Вызывает полнотекстовый поиск по категориям, услугам и тикетам
      class Search
        include Interactor::Organizer

        before do
          # Результат поиска.
          context.result = []
          # Атрибут еобходим для понимания, какие данные нужно выдать пользователю.
          context.question_attributes = question_attributes
        end

        organize SearchCategories, SearchServices, SearchTickets

        protected

        def question_attributes
          @question_attributes ||= QuestionPolicy.new(context.user, Question).attributes_for_search
        end
      end
    end
  end
end
