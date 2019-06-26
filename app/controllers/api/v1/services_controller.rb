module Api
  module V1
    class ServicesController < BaseController
      def index
        services = Service.includes(:category, tickets: :answers)

        render json: services, include: 'category,tickets.answers.attachments'
      end

      def show
        render json: Service.find_by(id: params[:id], category_id: params[:category_id]), include: 'category,tickets.answers.attachments'
      end
    end
  end
end
