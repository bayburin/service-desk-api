module Api
  module V1
    class TagsController < BaseController
      def index
        tags = if params[:search]
                 Tag.where('name LIKE :term', term: "#{params[:search]}%")
               else
                 Tag.all
               end

        render json: tags
      end
    end
  end
end
