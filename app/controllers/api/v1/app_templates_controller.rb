module Api
  module V1
    class AppTemplatesController < BaseController
      def create
        create = AppTemplates::Create.call(params: app_template_params)

        if create.success?
          render json: create.app_template, serializer: AppTemplates::AppTemplateBaseSerializer
        else
          render json: create.errors, status: :unprocessable_entity
        end
      end

      protected

      def app_template_params
        params.require(:app_template).permit(
          :id,
          :description,
          :destination,
          :message,
          :info,
          ticket: [
            :id,
            :service_id,
            :parent_id,
            :name,
            :is_hidden,
            tags: %i[id name],
            responsible_users: %i[id responseable_type responseable_id tn _destroy]
          ]
        )
      end
    end
  end
end
