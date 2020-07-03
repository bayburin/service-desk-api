module Api
  module V1
    module Questions
      class Create < ApplicationService
        def initialize(params)
          @params = params

          super
        end

        def call
          Ticket.with_advisory_lock('create_question') do
            @data = Tickets::TicketFactory.create(:question, params)
            return true if data.save

            errors.merge!(data.errors)
            return false
          end
        end
      end
    end
  end
end
