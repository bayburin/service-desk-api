module Api
  module V1
    class CategoriesController < BaseController
      def index
        render json: CategoriesQuery.new.all.includes(:services), include: 'services'
      end

      def show
        render json: Category.find(params[:id]), include: 'services,faq.answers.attachments'
      end
    end
  end
end
