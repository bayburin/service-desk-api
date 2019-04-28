module Api
  module V1
    class CategoriesController < BaseController
      impressionist

      def index
        render json: CategoriesQuery.new.visible
      end

      def show
        render json: Category.find(params[:id], is_hidden: false), include: 'services,faq.answers'
      end
    end
  end
end
