module Api
  module V1
    class TicketsController < BaseController
      # def index
      #   render json: Service.find(params[:service_id]).tickets
      # end

      def show
        render json: Ticket.find_by(id: params[:id], service_id: params[:service_id])
      end
    end
  end
end
