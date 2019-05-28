module Api
  module V1
    class TicketsController < BaseController
      impressionist

      # def index
      #   tickets = Ticket.where(service_id: params[:service_id], is_hidden: false).includes(:answers, service: :category)

      #   render json: tickets, include: 'answers,service.category'
      # end

      def show
        ticket = Ticket.find_by(service_id: params[:service_id], id: params[:id])
        ticket.calculate_popularity
        ticket.save

        render json: ticket, include: ''
      end
    end
  end
end
