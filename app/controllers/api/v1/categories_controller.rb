module Api
  module V1
    class CategoriesController < BaseController
      impressionist

      def index
        render json: Category.all
      end
    end
  end
end
