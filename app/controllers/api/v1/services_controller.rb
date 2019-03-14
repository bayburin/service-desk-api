module Api
  module V1
    class ServicesController < BaseController
      def index
        render json: Category.find(params[:category_id]).services
      end
    end
  end
end
