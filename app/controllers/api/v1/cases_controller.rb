module Api
  module V1
    class CasesController < BaseController
      before_action :doorkeeper_authorize!

      def index
        response = case_api_wrapper.query(filters: params[:filters])

        if response.status == 200
          render json: CaseDashboard.new(response.body), serializer: CaseDashboardSerializer, include: 'cases.service,cases.ticket,statuses'
        else
          render json: response.body, status: response.status
        end
      end

      def create
        kase = Case.new(cases_params)
        authorize kase

        case_decorator = CaseSaveDecorator.new(kase)
        case_decorator.decorate
        response = Cases::CaseApi.save(case_decorator.kase)

        render json: response.body, status: response.status
      end

      def destroy
        response = case_api_wrapper.destroy(case_id: params[:case_id])

        render json: response.body, status: response.status
      end

      protected

      def case_api_wrapper
        CaseApiPolicy::Scope.new(current_user, Cases::CaseApi).resolve
      end

      def cases_params
        params.require(:case).permit(
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
          :invent_num
        )
      end
    end
  end
end
