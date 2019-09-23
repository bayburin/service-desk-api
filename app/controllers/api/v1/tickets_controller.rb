module Api
  module V1
    class TicketsController < BaseController
      def index
        service = Service.find(params[:service_id])
        tickets = Api::V1::QuestionsQuery.new
                    .all_in_service(service)
                    .includes(:responsible_users, :tags, answers: :attachments)
        tickets = tickets.where(state: params[:state]) if params[:state]

        render json: tickets, include: 'responsible_users,tags,answers.attachments'
      end

      def show
        ticket = Ticket.find_by(service_id: params[:service_id], id: params[:id])
        authorize ticket

        ticket.calculate_popularity
        ticket.save

        render json: ticket, include: ''
      end

      def create
        ticket = Ticket.new(ticket_params)
        authorize ticket

        ticket.ticket_type = :question
        ticket.state = :draft
        ticket.to_approve = false

        if ticket.save
          render json: ticket
        else
          render json: ticket.errors, status: :unprocessable_entity
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
          answers_attributes: %i[id ticket_id reason answer link is_hidden],
          tags_attributes: %i[id name],
          responsible_users_attributes: %i[id tn]
        )
      end
    end
  end
end
