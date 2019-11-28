module Api
  module V1
    class ServicesController < BaseController
      def index
        policy_attributes = policy(Service).attributes_for_index
        services = policy_scope(Service.includes(policy_attributes.sql_include))

        render json: services, each_serializer: policy_attributes.serializer, include: 'category,tickets.answers.attachments'
      end

      def show
        service = Service.find_by(id: params[:id], category_id: params[:category_id])
        authorize service
        policy_attributes = policy(service).attributes_for_show

        render(
          json: service,
          serializer: policy_attributes.serializer,
          authorize_attributes: policy_attributes.sql_include,
          include: policy_attributes.serialize
        )
      end
    end
  end
end
