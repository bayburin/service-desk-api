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

      def create
        ticket = Ticket.new(ticket_params)
        ticket.ticket_type = :question
        ticket.state = :draft
        ticket.to_approve = false

        if ticket.save
          render json: ticket
        else
          render json: ticket.errors.details, status: :unprocessable_entity
        end
      end

      protected

      def ticket_params
        params.require(:ticket).permit(
          :id,
          :service_id,
          :parent_id,
          :name,
          :is_hidden,
          tags_attributes: %i[id name],
          answers_attributes: %i[id ticket_id reason answer link]
        )
      end
    end
  end
end
