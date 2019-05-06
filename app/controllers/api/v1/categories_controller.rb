module Api
  module V1
    class CategoriesController < BaseController
      impressionist

      def index
        render json: CategoriesQuery.new.all.includes(:services), include: 'services'
      end

      def show
        render json: Category.find(params[:id]), include: 'services,faq.answers'
      end
    end
  end
end
