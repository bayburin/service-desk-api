module Api
  module V1
    class ServicesController < BaseController
      def index
        services = policy_scope(Service.includes(:category, tickets: :answers))

        render json: services, include: 'category,tickets.answers.attachments'
      end

      def show
        service = Service.find_by(id: params[:id], category_id: params[:category_id])
        authorize service

        render json: service, include: 'category,tickets.answers.attachments'
      end
    end
  end
end
