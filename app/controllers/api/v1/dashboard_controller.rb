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
          sql: { include: policy_hash[:include] }
        ).each { |s| s.without_associations = true }
        tickets = TicketPolicy::SphinxScope.new(current_user, tickets).resolve

        render json: search_categories.to_a + search_services.to_a + tickets.to_a
      end

      def deep_search
        ahoy.track 'Deep search', params[:search]
        tickets = Ticket.search(
          ThinkingSphinx::Query.escape(params[:search]),
          order: 'popularity DESC',
          per_page: 1000,
          sql: { include: [:responsible_users, service: :responsible_users, answers: :attachments] }
        )
        tickets = TicketPolicy::SphinxScope.new(current_user, tickets).resolve

        render json: search_categories.to_a + search_services.to_a + tickets.to_a, include: 'service,answers.attachments'
      end

      protected

      def search_categories
        Category
          .search(ThinkingSphinx::Query.escape(params[:search]), order: 'popularity DESC', per_page: 1000)
          .each { |s| s.without_associations = true }
      end

      def search_services
        policy_hash = policy(Service).attributes_for_search
        services = Service.search(
          ThinkingSphinx::Query.escape(params[:search]),
          order: 'popularity DESC',
          per_page: 1000,
          sql: { include: policy_hash[:include] }
        ).each { |s| s.without_associations = true }
        ServicePolicy::SphinxScope.new(current_user, services).resolve
      end
    end
  end
end
