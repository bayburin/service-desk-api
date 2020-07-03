module Api
  module V1
    module Tickets
      class QuestionFactory
        def create(params = {})
          Question.new(params).tap do |question|
            if question.ticket
              question.ticket.state = :draft
              question.ticket.generate_identity unless question.ticket.identity
            end
          end
        end
      end
    end
  end
end
