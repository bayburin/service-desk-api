module Api
  module V1
    class QuestionDecorator < SimpleDelegator
      def initialize(question)
        __setobj__ question
      end

      def update_by_state(attributes)
        ticket_state.update(attributes) ? reload : false
      end

      def destroy_by_state
        ticket_state.destroy
      end

      def publish
        ticket_state.publish
      end

      def link_to_admin_ui(origin)
        "#{origin}/categories/#{service.category.id}/services/#{service.id}/admin/tickets?ticket=#{ticket.id}"
      end

      protected

      def ticket_state
        __getobj__.ticket.published_state? ? Api::V1::Questions::PublishedState.new(self) : Api::V1::Questions::DraftState.new(self)
      end
    end
  end
end
