module Api
  module V1
    class QuestionsQuery < TicketsQuery
      def all
        questions.includes(answers: :attachments).by_popularity
      end

      def visible
        questions.visible.includes(answers: :attachments).by_popularity
      end

      def most_popular
        visible.published.limit(5)
      end

      private

      def questions
        scope.where(ticket_type: :question).where(original: nil).extend(TicketScope)
      end
    end
  end
end
