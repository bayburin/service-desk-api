module Api
  module V1
    class TicketsController < BaseController
      def show
        ticket = Ticket.find_by(service_id: params[:service_id], id: params[:id])
        authorize ticket

        ticket.calculate_popularity
        ticket.save

        render json: ticket, include: ''
      end
    end
  end
end
