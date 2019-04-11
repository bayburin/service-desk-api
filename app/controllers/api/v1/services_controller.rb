module Api
  module V1
    class ServicesController < BaseController
      impressionist

      def index
        services = Service.where(category_id: params[:category_id], is_hidden: false).includes(:category)

        render json: services, include: 'category'
      end

      def show
        render json: Service.find_by(id: params[:id]), include: 'category'
      end
    end
  end
end
