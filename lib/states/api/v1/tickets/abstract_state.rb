module Api
  module V1
    module Tickets
      class AbstractState
        attr_reader :object

        def initialize(ticket)
          @ticket = ticket
        end

        def update
          raise 'Необходимо реализовать метод update'
        end
      end
    end
  end
end
