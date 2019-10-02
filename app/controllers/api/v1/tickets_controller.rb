module Api
  module V1
    class TicketsController < BaseController
      def index
        tickets = Api::V1::QuestionsQuery.new
                    .all_in_service(Service.find(params[:service_id]))
                    .includes(:correction, :responsible_users, :tags, answers: :attachments)
        tickets = tickets.where(state: params[:state]) if params[:state]

        render json: tickets, include: 'correction,responsible_users,tags,answers.attachments,correction.*,correction.answers.attachments'
      end

      def show
        ticket = Service.find(params[:service_id]).tickets.find(params[:id])

        render json: ticket
      end

      def create
        ticket = Ticket.new(attributive_params)
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

      def update
        ticket = Service.find(params[:service_id]).tickets.find(params[:id])
        decorated_ticket = TicketDecorator.new(ticket)

        if decorated_ticket.update_by_state(attributive_params)
          render json: decorated_ticket
        else
          render json: decorated_ticket.errors, status: :unprocessable_entity
        end
      end

      def raise_rating
        ticket = Ticket.find_by(service_id: params[:service_id], id: params[:id])
        # authorize ticket, :show?

        ticket.calculate_popularity
        ticket.save
      end

      protected

      def ticket_params
        params.require(:ticket).permit(
          :id,
          :service_id,
          :parent_id,
          :name,
          :is_hidden,
          answers: %i[id _destroy ticket_id reason answer link is_hidden],
          tags: %i[id name _destroy],
          responsible_users: %i[id tn]
        )
      end

      def attributive_params
        attributive_params = ticket_params
        attributive_params[:answers_attributes] = attributive_params.delete(:answers) || []
        attributive_params[:tags_attributes] = attributive_params.delete(:tags) || []
        # attributive_params[:responsible_users_attributes] = attributive_params.delete(:responsible_users)
        attributive_params
      end
    end
  end
end
