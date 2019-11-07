module Api
  module V1
    class QuestionsQuery < TicketsQuery
      def all
        questions.includes(answers: :attachments).by_popularity
      end

      def visible
        questions.visible.by_popularity
      end

      def most_popular
        visible.published.by_visible_service.limit(5)
      end

      def waiting_for_publish(ids = [])
        scope.where(state: :draft, id: ids)
      end

      private

      def questions
        scope.where(ticket_type: :question).where(original: nil).extend(TicketScope)
      end
    end
  end
end
