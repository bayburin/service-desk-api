module Api
  module V1
    module Tickets
      class QuestionFactory
        def create(params = {})
          Ticket.new(params).tap do |ticket|
            ticket.ticket_type = :question
            ticket.state = :draft
            ticket.to_approve = false
          end
        end
      end
    end
  end
end
