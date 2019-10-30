module Api
  module V1
    class DashboardController < BaseController
      def index
        categories = CategoriesQuery.new.all.limit(9)
        services = ServicesQuery.new.most_popular.includes(:tickets).each do |service|
          service.tickets.each(&:without_associations!)
        end
        user_recommendations = UserRecommendation.order(:order)

        render(
          json: Dashboard.new(categories, services, user_recommendations),
          serializer: DashboardSerializer,
          include: 'categories,services.tickets,user_recommendations'
        )
      end

      def search
        ahoy.track 'Search', params[:search]
        policy_attributes = policy(Ticket).attributes_for_search

        render json: search_categories + search_services + search_tickets(policy_attributes)
      end

      def deep_search
        ahoy.track 'Deep search', params[:search]
        policy_attributes = policy(Ticket).attributes_for_deep_search

        render json: search_categories + search_services + search_tickets(policy_attributes)
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

      def search_tickets(policy_attributes)
        tickets = Ticket.search(
          ThinkingSphinx::Query.escape(params[:search]),
          order: 'popularity DESC',
          per_page: 1000,
          sql: { include: policy_attributes.sql_include }
        )
        tickets = TicketPolicy::SphinxScope.new(current_user, tickets).resolve

        ActiveModel::Serializer::CollectionSerializer.new(tickets, serializer: policy_attributes.serializer)
          .as_json(include: policy_attributes.serialize)
      end
    end
  end
end
