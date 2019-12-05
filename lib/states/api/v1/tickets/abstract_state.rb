module Api
  module V1
    module Tickets
      class AbstractState
        attr_reader :ticket

        def initialize(ticket)
          @ticket = ticket
        end

        def update
          raise 'Необходимо реализовать метод update'
        end

        def publish
          raise 'Необходимо реализовать метод publish'
        end
      end
    end
  end
end
