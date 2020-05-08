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
        question_ticket = Service.find(params[:service_id]).question_tickets.find(params[:id])

        render(
          json: question_ticket,
          serializer: QuestionTickets::QuestionTicketResponsibleUserSerializer,
          include: ['*', 'ticket.*']
        )
      end

      def create
        question_ticket = Tickets::TicketFactory.create(:question, attributive_params)

        if question_ticket.save
          # FIXME: Исправить воркер. Он работает на id Ticket, а не QuestionTicket
          NotifyContentManagersWorker.perform_async(question_ticket.id, current_user.tn, 'create', request.headers['origin'])

          render json: question_ticket, serializer: QuestionTickets::QuestionTicketResponsibleUserSerializer
        else
          render json: question_ticket.errors, status: :unprocessable_entity
        end
      end

      def update
        question_ticket = Service.find(params[:service_id]).question_tickets.find(params[:id])
        authorize question_ticket
        decorated_ticket = QuestionTicketDecorator.new(question_ticket)

        if decorated_ticket.update_by_state(attributive_params)
          policy_attributes = policy(QuestionTicket).attributes_for_show
          # FIXME: Исправить воркер. Он работает на id Ticket, а не QuestionTicket
          NotifyContentManagersWorker.perform_async(decorated_ticket.original.try(:id) || decorated_ticket.id, current_user.tn, 'update', request.headers['origin'])

          render json: decorated_ticket, serializer: policy_attributes.serializer, include: policy_attributes.serialize
        else
          render json: decorated_ticket.errors, status: :unprocessable_entity
        end
      end

      def destroy
        question_ticket = Service.find(params[:service_id]).question_tickets.find(params[:id])
        authorize Ticket
        decorated_ticket = QuestionTicketDecorator.new(question_ticket)

        if decorated_ticket.destroy_by_state
          render json: question_ticket
        else
          render json: question_ticket.errors, status: :unprocessable_entity
        end
      end

      def raise_rating
        ticket = Ticket.find_by(service_id: params[:service_id], id: params[:id])
        authorize ticket

        ticket.calculate_popularity
        ticket.save
      end

      def publish
        authorize Ticket

        question_tickets = QuestionTicketsQuery.new.waiting_for_publish(params[:ids].split(','))
        published = question_tickets.map do |question|
          decorated_ticket = QuestionTicketDecorator.new(question)
          decorated_ticket.publish ? question.reload : nil
        end
        policy_attributes = policy(QuestionTicket).attributes_for_show

        render json: published, each_serializer: policy_attributes.serializer, include: policy_attributes.serialize
      end

      protected

      def ticket_params
        params.require(:question).permit(
          :id,
          ticket: [
            :id,
            :service_id,
            :parent_id,
            :name,
            :is_hidden,
            tags: %i[id name _destroy],
            responsible_users: %i[id responseable_type responseable_id tn _destroy]
          ],
          answers: %i[id _destroy ticket_id reason answer link is_hidden],
        )
      end

      def attributive_params
        attributive_params = ticket_params
        attributive_params[:answers_attributes] = attributive_params.delete(:answers) || []
        attributive_params[:ticket][:tags_attributes] = attributive_params[:ticket].delete(:tags) || []
        attributive_params[:ticket][:responsible_users_attributes] = attributive_params[:ticket].delete(:responsible_users) || []
        attributive_params[:ticket_attributes] = attributive_params.delete(:ticket)
        attributive_params
      end

      def check_access
        authorize Service.find(params[:service_id]), :tickets_ctrl_access?
      end
    end
  end
end
