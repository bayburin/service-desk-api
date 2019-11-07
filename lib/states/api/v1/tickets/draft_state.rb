module Api
  module V1
    module Tickets
      class DraftState < AbstractState
        def update(attributes)
          @object = @ticket.update(attributes)
        end

        def publish
          if @ticket.original
            popularity = @ticket.original.popularity

            Ticket.transaction do
              @ticket.original.destroy && @ticket.update(state: :published, popularity: popularity)
            end
          else
            @ticket.update(state: :published)
          end
        end
      end
    end
  end
end
