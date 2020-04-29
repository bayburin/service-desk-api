module Api
  module V1
    class TicketsController < BaseController
      before_action :check_access, except: %i[raise_rating update publish]

      def index
        policy_attributes = policy(QuestionTicket).attributes_for_show
        questions = Api::V1::QuestionTicketsQuery.new
                      .all_in_service(Service.find(params[:service_id]))
                      .includes(policy_attributes.sql_include)
                      .draft

        render(json: questions, each_serializer: policy_attributes.serializer, include: policy_attributes.serialize)
      end

      def show
        ticket = Service.find(params[:service_id]).tickets.find(params[:id])

        render json: ticket, serializer: Tickets::TicketResponsibleUserSerializer
      end

      def create
        ticket = Tickets::TicketFactory.create(:question, attributive_params)

        if ticket.save
          NotifyContentManagersWorker.perform_async(ticket.id, current_user.tn, 'create', request.headers['origin'])

          render json: ticket, serializer: Tickets::TicketResponsibleUserSerializer
        else
          render json: ticket.errors, status: :unprocessable_entity
        end
      end

      def update
        ticket = Service.find(params[:service_id]).tickets.find(params[:id])
        authorize ticket
        decorated_ticket = TicketDecorator.new(ticket)

        if decorated_ticket.update_by_state(attributive_params)
          policy_attributes = policy(Ticket).attributes_for_show
          NotifyContentManagersWorker.perform_async(decorated_ticket.original.try(:id) || decorated_ticket.id, current_user.tn, 'update', request.headers['origin'])

          render json: decorated_ticket, serializer: policy_attributes.serializer, include: policy_attributes.serialize
        else
          render json: decorated_ticket.errors, status: :unprocessable_entity
        end
      end

      def destroy
        ticket = Service.find(params[:service_id]).tickets.find(params[:id])
        authorize ticket
        decorated_ticket = TicketDecorator.new(ticket)

        if decorated_ticket.destroy_by_state
          render json: ticket
        else
          render json: ticket.errors, status: :unprocessable_entity
        end
      end

      def raise_rating
        ticket = Ticket.find_by(service_id: params[:service_id], id: params[:id])
        authorize ticket

        ticket.calculate_popularity
        ticket.save
      end

      def publish
        authorize Ticket, :publish?

        tickets = QuestionTicketsQuery.new.waiting_for_publish(params[:ids].split(','))
        published = tickets.map do |ticket|
          decorated_ticket = TicketDecorator.new(ticket)
          decorated_ticket.publish ? ticket.reload : nil
        end
        policy_attributes = policy(Ticket).attributes_for_show

        render json: published, each_serializer: policy_attributes.serializer, include: policy_attributes.serialize
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
          responsible_users: %i[id responseable_type responseable_id tn _destroy]
        )
      end

      def attributive_params
        attributive_params = ticket_params
        attributive_params[:answers_attributes] = attributive_params.delete(:answers) || []
        attributive_params[:tags_attributes] = attributive_params.delete(:tags) || []
        attributive_params[:responsible_users_attributes] = attributive_params.delete(:responsible_users) || []
        attributive_params
      end

      def check_access
        authorize Service.find(params[:service_id]), :tickets_ctrl_access?
      end
    end
  end
end
