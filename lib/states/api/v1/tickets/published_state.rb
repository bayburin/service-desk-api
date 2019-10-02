module Api
  module V1
    module Tickets
      class PublishedState < AbstractState
        def update(attributes)
          cleared_attributes = clear_attributes(attributes)
          @object = @ticket.build_correction(cleared_attributes)
          object.state = :draft
          object.ticket_type = :question

          object.save
        end

        protected

        def clear_attributes(attributes)
          attributes[:id] = nil
          attributes[:answers_attributes].each do |answer|
            answer[:ticket] = nil
            answer[:id] = nil
          end
          attributes
        end
      end
    end
  end
end
