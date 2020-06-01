module Api
  module V1
    class DashboardController < BaseController
      def index
        categories = CategoriesQuery.new.all.limit(9)
        services = ServicesQuery.new.most_popular.includes(:questions).each do |service|
          service.questions.each(&:without_associations!)
        end
        user_recommendations = UserRecommendation.order(:order)

        render(
          json: Dashboard.new(categories, services, user_recommendations),
          serializer: DashboardSerializer,
          include: 'categories,services.questions,user_recommendations'
        )
      end

      def search
        ahoy.track 'Search', params[:search]

        render json: search_categories + search_services + search_tickets
      end

      def deep_search
        ahoy.track 'Deep search', params[:search]

        render json: search_categories + search_services + deep_search_tickets
      end

      protected

      def search_categories
        categories = Category
                       .search(ThinkingSphinx::Query.escape(params[:search]), order: 'popularity DESC', per_page: 1000)
                       .each(&:without_associations!)
        ActiveModel::Serializer::CollectionSerializer.new(categories, serializer: Categories::CategoryGuestSerializer).as_json
      end

      def search_services
        policy_attributes = policy(Service).attributes_for_search
        services = Service.search(
          ThinkingSphinx::Query.escape(params[:search]),
          order: 'popularity DESC',
          per_page: 1000,
          sql: { include: policy_attributes.sql_include }
        )
        services = ServicePolicy::SphinxScope.new(current_user, services).resolve
        ActiveModel::Serializer::CollectionSerializer.new(services, serializer: Services::ServiceGuestSerializer)
          .as_json(include: policy_attributes.serialize)
      end

      def search_tickets
        policy_attributes = policy(Question).attributes_for_search
        serialize_questions(find_tickets, policy_attributes)
      end

      def deep_search_tickets
        question_policy_attributes = policy(Question).attributes_for_deep_search
        # case_policy_attributes = policy(CaseTicket).attributes_for_deep_search

        serialize_questions(find_tickets, question_policy_attributes)
      end

      def find_tickets
        tickets = Ticket.search(
          ThinkingSphinx::Query.escape(params[:search]),
          order: 'popularity DESC',
          per_page: 1000,
          sql: { include: :service }
        )
        TicketPolicy::SphinxScope.new(current_user, tickets).resolve
      end

      def serialize_questions(tickets, policy_attributes)
        question_ids = tickets.select { |ticket| ticket.ticketable_type == 'Question' }.map(&:ticketable_id)
        questions = Question.where(id: question_ids).includes(policy_attributes.sql_include)

        ActiveModel::Serializer::CollectionSerializer.new(questions, serializer: policy_attributes.serializer)
          .as_json(include: policy_attributes.serialize)
      end

      # def serialize_cases(tickets, policy_attributes)
      #   case_ids = tickets.select { |ticket| ticket.ticketable_type == 'CaseTicket' }.map(&:ticketable_id)
      #   cases = CaseTicket.where(id: case_ids).includes(policy_attributes.sql_include)

      #   ActiveModel::Serializer::CollectionSerializer.new(cases, serializer: policy_attributes.serializer)
      #     .as_json(include: policy_attributes.serialize)
      # end
    end
  end
end
