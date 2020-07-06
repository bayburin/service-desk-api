module Api
  module V1
    module Questions
      class Publish < ApplicationService
        validates :answers, :ticket, presence: true

        def initialize(question)
          @data = question

          super
        end

        def answers
          data.answers
        end

        def ticket
          data.ticket
        end

        def call
          return false unless valid?

          if data.original
            popularity = data.original.ticket.popularity

            Question.transaction do
              data.original.destroy && data.ticket.update(state: :published, popularity: popularity)
            end
          else
            data.ticket.update(state: :published)
          end
        end
      end
    end
  end
end
