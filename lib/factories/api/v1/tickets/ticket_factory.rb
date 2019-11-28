module Api
  module V1
    module Tickets
      class TicketFactory
        def self.create(type, params = {})
          TicketInitializer.for(type).create(params)
        end
      end
    end
  end
end
