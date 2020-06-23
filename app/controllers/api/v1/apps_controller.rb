module Api
  module V1
    class AppsController < BaseController
      def index
        response = app_api_wrapper.query(filters: params[:filters])

        if response.success?
          render json: AppDashboard.new(response.body), serializer: AppDashboardSerializer, include: 'apps.service,apps.ticket,statuses'
        else
          render json: response.body, status: response.status
        end
      end

      def create
        app = AppFactory.create(apps_params)
        authorize app

        app_decorator = AppSaveDecorator.new(app)
        app_decorator.decorate
        response = AppApi.save(app_decorator.app)

        render json: response.body, status: response.status
      end

      def update
        app = AppFactory.create(apps_params)
        authorize app

        logger.debug { "Application before update: #{app}" }
        response = AppApi.update(params[:case_id], app)

        render json: response.body, status: response.status
      end

      def destroy
        response = app_api_wrapper.destroy(case_id: params[:case_id])

        render json: response.body, status: response.status
      end

      protected

      def app_api_wrapper
        AppApiPolicy::Scope.new(current_user, AppApi).resolve
      end

      def apps_params
        params.require(:app).permit(
          :case_id,
          :id_tn,
          :user_tn,
          :fio,
          :dept,
          :email,
          :phone,
          :mobile,
          :desc,
          :without_service,
          :without_item,
          :service_id,
          :item_id,
          :invent_num,
          :rating,
          additional: [:comment],
          files: %i[filename file]
        )
      end
    end
  end
end
