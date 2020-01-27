module Api
  module V1
    module Tickets
      class PublishedState < AbstractState
        def update(attributes)
          update_ticket = UpdatePublishedTicket.new(ticket)
          return true if update_ticket.update(attributes)

          ticket.errors.merge!(update_ticket.errors)
          false
        end

        def publish
          raise 'Вопрос уже опубликован'
        end

        def destroy
          if ticket.correction
            Ticket.transaction do
              ticket.correction.destroy && ticket.destroy
            end
          else
            ticket.destroy
          end
        end
      end
    end
  end
end
