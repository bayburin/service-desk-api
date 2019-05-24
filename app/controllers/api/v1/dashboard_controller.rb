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
        data = ThinkingSphinx
                 .search(params[:search], order: 'popularity DESC', per_page: 1000)
                 .each { |s| s.without_associations = true }

        render json: data, include: 'answers.attachments'
      end
    end
  end
end
