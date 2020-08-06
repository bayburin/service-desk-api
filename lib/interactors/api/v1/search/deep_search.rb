module Api
  module V1
    module Search
      # Вызывает полнотекстовый поиск по категориям, услугам и тикетам. Для тикетов в ответе выдает больше данных, чем класс Search.
      class DeepSearch
        include Interactor::Organizer

        before do
          # Результат поиска.
          context.result = []
          # Атрибут еобходим для понимания, какие данные нужно выдать пользователю.
          context.question_attributes = question_attributes
          # application_policy_attributes = policy(Application).attributes_for_deep_search
        end

        organize SearchCategories, SearchServices, SearchTickets

        protected

        def question_attributes
          @question_attributes ||= QuestionPolicy.new(context.user, Question).attributes_for_deep_search
        end
      end
    end
  end
end
