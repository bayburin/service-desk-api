module Api
  module V1
    class QuestionsQuery < TicketsQuery
      def all
        questions.includes(:answers).by_popularity
      end

      def visible
        questions.visible.includes(:answers).by_popularity
      end

      def most_popular
        visible.limit(5)
      end

      private

      def questions
        scope.where(ticket_type: :question)
      end
    end
  end
end
