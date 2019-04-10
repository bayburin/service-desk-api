module Api
  module V1
    class CategoriesController < BaseController
      impressionist

      def index
        render json: Category.extend(Scope).includes(:services).by_popularity
      end
    end
  end
end
