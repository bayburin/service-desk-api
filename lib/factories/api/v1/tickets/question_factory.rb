module Api
  module V1
    module Tickets
      class QuestionFactory
        def create(params = {})
          Question.new(params).tap do |question|
            question.ticket.state = :draft if question.ticket
          end
        end
      end
    end
  end
end
