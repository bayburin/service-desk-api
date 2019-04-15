module Api
  module V1
    class DashboardController < BaseController
      def index
        categories = Category.extend(Scope).by_popularity
        services = Service.extend(Scope).by_popularity.includes(:tickets)

        render json: Dashboard.new(categories, services), serializer: DashboardSerializer, include: 'categories,services.tickets'
      end

      def search
        data = ThinkingSphinx
                 .search(params[:search], order: 'popularity DESC')
                 .each { |s| s.without_associations = true }

        render json: data
      end
    end
  end
end
