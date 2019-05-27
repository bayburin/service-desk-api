module Api
  module V1
    class DashboardController < BaseController
      def index
        categories = CategoriesQuery.new.all.limit(9)
        services = ServicesQuery.new.most_popular.includes(:tickets).each do |service|
          service.tickets.each(&:without_associations!)
        end

        render json: Dashboard.new(categories, services), serializer: DashboardSerializer, include: 'categories,services.tickets'
      end

      def search
        tickets = Ticket.search(ThinkingSphinx::Query.escape(params[:search]), order: 'popularity DESC', per_page: 1000, sql: { include: :service }).each { |s| s.without_associations = true }

        render json: search_categories.to_a + search_services.to_a + tickets.to_a
      end

      def deep_search
        tickets = Ticket.search(ThinkingSphinx::Query.escape(params[:search]), order: 'popularity DESC', per_page: 1000, sql: { include: [:service, answers: :attachments] })

        render json: search_categories.to_a + search_services.to_a + tickets.to_a, include: 'service,answers.attachments'
      end

      protected

      def search_categories
        Category.search(ThinkingSphinx::Query.escape(params[:search]), order: 'popularity DESC', per_page: 1000).each { |s| s.without_associations = true }
      end

      def search_services
        Service.search(ThinkingSphinx::Query.escape(params[:search]), order: 'popularity DESC', per_page: 1000).each { |s| s.without_associations = true }
      end
    end
  end
end
