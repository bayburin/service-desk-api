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
        policy_hash = policy(Ticket).attributes_for_search
        tickets = Ticket.search(
          ThinkingSphinx::Query.escape(params[:search]),
          order: 'popularity DESC',
          per_page: 1000,
          sql: { include: policy_hash.sql_include }
        ).each { |s| s.without_associations = true }
        tickets = TicketPolicy::SphinxScope.new(current_user, tickets).resolve

        render(
          json: search_categories.as_json + search_services.as_json + serialize_tickets(tickets, Tickets::TicketGuestSerializer).as_json
        )
      end

      def deep_search
        ahoy.track 'Deep search', params[:search]
        policy_hash = policy(Ticket).attributes_for_deep_search
        tickets = Ticket.search(
          ThinkingSphinx::Query.escape(params[:search]),
          order: 'popularity DESC',
          per_page: 1000,
          sql: { include: policy_hash.sql_include }
        )
        tickets = TicketPolicy::SphinxScope.new(current_user, tickets).resolve

        render(
          json: search_categories.as_json + search_services.as_json + serialize_tickets(tickets, policy_hash.serializer)
            .as_json(include: 'service,answers.attachments')
        )
      end

      protected

      def search_categories
        categories = Category
                       .search(ThinkingSphinx::Query.escape(params[:search]), order: 'popularity DESC', per_page: 1000)
                       .each { |s| s.without_associations = true }
        ActiveModel::Serializer::CollectionSerializer.new(categories, serializer: Categories::CategoryGuestSerializer)
      end

      def search_services
        policy_hash = policy(Service).attributes_for_search
        services = Service.search(
          ThinkingSphinx::Query.escape(params[:search]),
          order: 'popularity DESC',
          per_page: 1000,
          sql: { include: policy_hash.sql_include }
        ).each { |s| s.without_associations = true }
        services = ServicePolicy::SphinxScope.new(current_user, services).resolve
        ActiveModel::Serializer::CollectionSerializer.new(services, serializer: Services::ServiceGuestSerializer)
      end

      def serialize_tickets(tickets, serializer)
        ActiveModel::Serializer::CollectionSerializer.new(tickets, serializer: serializer)
      end
    end
  end
end
