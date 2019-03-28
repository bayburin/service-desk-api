module Api
  module V1
    class DashboardController < BaseController
      def index
        categories = Category.all.by_popularity.each { |c| c.without_associations = true }
        services = Service.all.by_popularity.includes(:category).each { |s| s.without_category = true }

        render json: Dashboard.new(categories, services), serializer: DashboardSerializer
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
