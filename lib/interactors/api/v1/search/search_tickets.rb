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
          context.questions = Question.where(id: question_ids).includes(context.question_attributes.sql_include)
          (context.result ||= []).concat(
            ActiveModel::Serializer::CollectionSerializer.new(context.questions, serializer: context.question_attributes.serializer)
              .as_json(include: context.question_attributes.serialize)
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

        # def serialize_apps(tickets, policy_attributes)
        #   app_ids = tickets.select { |ticket| ticket.ticketable_type == 'Application' }.map(&:ticketable_id)
        #   apps = Application.where(id: app_ids).includes(policy_attributes.sql_include)

        #   ActiveModel::Serializer::CollectionSerializer.new(apps, serializer: policy_attributes.serializer)
        #     .as_json(include: policy_attributes.serialize)
        # end
      end
    end
  end
end
