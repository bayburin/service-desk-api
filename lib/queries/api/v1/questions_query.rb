module Api
  module V1
    class QuestionsQuery < ApplicationQuery
      def initialize(scope = Question.all)
        @scope = scope.includes(:ticket)
      end

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
        scope.where(tickets: { state: :draft }, id: ids)
      end

      def all_in_service(service)
        all.joins(:ticket).where(tickets: { service: service }).extend(TicketScope)
      end

      private

      def questions
        scope.where(original: nil).extend(TicketScope)
      end
    end
  end
end
