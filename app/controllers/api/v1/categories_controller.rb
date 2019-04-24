module Api
  module V1
    class CategoriesController < BaseController
      impressionist

      def index
        render json: Category.extend(Scope).includes(:services).by_popularity
      end

      def show
        render json: Category.find(params[:id]), include: 'services,faq.answers'
      end
    end
  end
end
