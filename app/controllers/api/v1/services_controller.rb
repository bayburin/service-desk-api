module Api
  module V1
    class ServicesController < BaseController
      def index
        render json: Category.find(params[:category_id]).services.includes(:tickets)
      end

      def show
        render json: Service.find(params[:id]).tickets.includes(:tags)
      end
    end
  end
end
