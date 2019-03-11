module Api
  module V1
    class CategoriesController < ApplicationController
      def index
        # render json: Category.all
        render json: TicketProperty.all
      end
    end
  end
end
