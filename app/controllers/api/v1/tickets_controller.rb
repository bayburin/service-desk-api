module Api
  module V1
    class TicketsController < BaseController
      impressionist

      # def index
      #   tickets = Ticket.where(service_id: params[:service_id], is_hidden: false).includes(:answers, service: :category)

      #   render json: tickets, include: 'answers,service.category'
      # end

      # def show
      #   render json: Api::V1::TicketsQuery.new.visible.find(params[:id]), include: 'service.category'
      # end
    end
  end
end
