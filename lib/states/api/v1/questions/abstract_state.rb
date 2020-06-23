module Api
  module V1
    module Questions
      class AbstractState
        attr_reader :question

        def initialize(question)
          @question = question
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
