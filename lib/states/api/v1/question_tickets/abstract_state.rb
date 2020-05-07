module Api
  module V1
    module QuestionTickets
      class AbstractState
        attr_reader :question_ticket

        def initialize(question_ticket)
          @question_ticket = question_ticket
        end

        def update
          raise 'Необходимо реализовать метод update'
        end

        def publish
          raise 'Необходимо реализовать метод publish'
        end

        def destroy
          raise 'Необходимо реализовать метод destroy'
        end
      end
    end
  end
end
