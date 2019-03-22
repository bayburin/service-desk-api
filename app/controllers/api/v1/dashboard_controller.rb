module Api
  module V1
    class DashboardController < BaseController
      def index
        categories = Category.all.by_popularity.each { |s| s.without_associations = params[:without_associations].to_s == 'true' }
        services = Service.all.by_popularity.includes(:tickets)

        render json: Dashboard.new(categories, services), serializer: DashboardSerializer, include: '**'
      end

      def search
        data = ThinkingSphinx
                 .search(params[:search], order: 'popularity DESC')
                 .each { |s| s.without_associations = params[:without_associations].to_s == 'true' }

        render json: data
      end
    end
  end
end
