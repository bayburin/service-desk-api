module Api
  module V1
    module Tickets
      class TicketInitializer
        def self.for(type)
          case type.to_sym
          when :app_form
            # Тут фабрика, создающая форму заявки
          when :question
            QuestionFactory.new
          else
            raise 'Неизвестный тип Ticket'
          end
        end
      end
    end
  end
end
