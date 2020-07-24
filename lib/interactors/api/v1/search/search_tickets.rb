module Api
  module V1
    module Search
      # Поиск по тикетам
      class SearchTickets
        include Interactor

        def call
          context.tickets = TicketPolicy::SphinxScope.new(context.user, search_tickets).resolve

          # Поиск и обработка вопросов
          question_ids = context.tickets.select(&:question?).map(&:ticketable_id)
          context.questions = Question.where(id: question_ids).includes(question_attributes.sql_include)
          (context.result ||= []).concat(
            ActiveModel::Serializer::CollectionSerializer.new(context.questions, serializer: question_attributes.serializer)
              .as_json(include: question_attributes.serialize)
          )
        end

        protected

        def search_tickets
          Ticket.search(
            ThinkingSphinx::Query.escape(context.term),
            order: 'popularity DESC',
            per_page: 1000,
            sql: { include: :service }
          )
        end

        def question_attributes
          @question_attributes ||= QuestionPolicy.new(context.user, Question).attributes_for_search
        end
      end
    end
  end
end
