module Api
  module V1
    class ServicesController < BaseController
      def index
        services = policy_scope(Service.includes(:category, tickets: :answers))

        # FIXME: Тут использовать сериалайзер взависимости от роли
        render json: services, each_serializer: Services::ServiceGuestSerializer, include: 'category,tickets.answers.attachments'
      end

      def show
        service = Service.find_by(id: params[:id], category_id: params[:category_id])
        authorize service
        policy_hash = policy(service).attributes_for_show

        render(
          json: service,
          serializer: policy_hash[:serializer],
          authorize_attributes: policy_hash[:include],
          include: policy_hash[:serialize]
        )
      end
    end
  end
end
