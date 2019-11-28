module Api
  module V1
    module Tickets
      class CaseFactory
        def create(params = {})
          Case.new(params)
        end
      end
    end
  end
end
