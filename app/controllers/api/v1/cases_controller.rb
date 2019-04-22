module Api
  module V1
    class CasesController < BaseController
      before_action :doorkeeper_authorize!

      def index
        case_dashboard = CaseApiPolicy::Scope.new(current_user, Cases::CaseApi).resolve.query(filters: params[:filters])

        render json: CaseDashboard.new(case_dashboard), serializer: CaseDashboardSerializer, include: 'cases.service,cases.ticket,statuses'
      end

      def create
        kase = Case.new(cases_params)
        authorize kase

        case_decorator = CaseSaveDecorator.new(kase)
        case_decorator.decorate

        if kase = Cases::CaseApi.save(case_decorator.kase)
          render json: kase
        else
          render json: { message: 'Ошибка' }, status: :unprocessable_entity
        end
      end

      # def destroy
      #   @case = Case.find(params[:case_id])

      #   if @case.destroy
      #     render json: { message: 'Заявка удалена' }
      #   else
      #     render json: @case.errors.full_messages.join('. '), status: :unprocessable_entity
      #   end
      # end

      protected

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
