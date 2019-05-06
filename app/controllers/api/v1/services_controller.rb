module Api
  module V1
    class ServicesController < BaseController
      impressionist

      def index
        services = Service.includes(:category, tickets: :answers)

        render json: services, include: 'category,tickets.answers'
      end

      def show
        render json: Service.find_by(id: params[:id], category_id: params[:category_id]), include: 'category,tickets.answers'
      end
    end
  end
end
