module Api
  module V1
    class CasesController < BaseController
      impressionist

      def index
        render json: Case.all
      end

      def show
        @case = Case.find(params[:case_id])
        impressionist(@case, 'Кейс найден')

        render json: @case
      end

      def create
        @case = Case.new(params[:case_id])

        if @case.save
          impressionist(@case, 'Кейс создан')
          render json: @case.id
        else
          render json: @case.errors.full_messages.join('. ')
        end
      end

      def update
        @case = Case.find(params[:case_id])

        if @case.update(cases_params)
          impressionist(@case, 'Кейс обновлен')
          render json: @case.id
        else
          render json: @case.errors.full_messages.join('. ')
        end
      end

      def destroy
        @case = Case.find(params[:case_id])

        if @case.destroy
          impressionist(@case, 'Кейс удален')
          render json: { message: 'Заявка удалена' }
        else
          render json: @case.errors.full_messages.join('. ')
        end
      end

      protected

      def cases_params
        params.require(:case).permit(:case_id)
      end
    end
  end
end
