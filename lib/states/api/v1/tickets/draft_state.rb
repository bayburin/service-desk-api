module Api
  module V1
    module Tickets
      class DraftState < AbstractState
        def update(attributes)
          @object = @ticket.update(attributes)
        end
      end
    end
  end
end
