module Api
  module V1
    class CasesController < BaseController
      before_action :doorkeeper_authorize!

      def index
        render json: policy_scope(Case)
      end

      def create
        @case = CaseSaveProxy.new(
          Case.new(cases_params)
        )
        authorize @case.kase

        if @case.save
          render json: @case.kase
        else
          render json: @case.kase.errors.full_messages.join('. '), status: :unprocessable_entity
        end
      end

      def destroy
        @case = Case.find(params[:case_id])

        if @case.destroy
          render json: { message: 'Заявка удалена' }
        else
          render json: @case.errors.full_messages.join('. '), status: :unprocessable_entity
        end
      end

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
