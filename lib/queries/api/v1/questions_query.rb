module Api
  module V1
    class QuestionsQuery < TicketsQuery
      def all
        scope.where(ticket_type: :question).includes(:answers).by_popularity
      end
    end
  end
end
