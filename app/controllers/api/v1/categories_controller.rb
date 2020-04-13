module Api
  module V1
    class CategoriesController < BaseController
      def index
        render json: CategoriesQuery.new.all, each_serializer: Categories::CategoryBaseSerializer, include: 'services'
      end

      def show
        category = Category.find(params[:id])
        policy_attributes = policy(category).attributes_for_show

        render json: category, serializer: policy_attributes.serializer, include: 'services,faq.*,faq.answers.attachments'
      end
    end
  end
end
