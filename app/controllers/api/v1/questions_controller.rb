module Api
  module V1
    class QuestionsController < BaseController
      before_action :check_access, except: %i[raise_rating update publish]

      def index
        policy_attributes = policy(Question).attributes_for_show
        questions = Api::V1::QuestionsQuery.new
                      .all_in_service(Service.find(params[:service_id]))
                      .includes(policy_attributes.sql_include)
                      .draft

        render(json: questions, each_serializer: policy_attributes.serializer, include: policy_attributes.serialize)
      end

      def show
        question = Service.find(params[:service_id]).questions.find(params[:id])

        render(
          json: question,
          serializer: Questions::QuestionResponsibleUserSerializer,
          include: ['*', 'ticket.*']
        )
      end

      def create
        question = Tickets::TicketFactory.create(:question, attributive_params)

        if question.save
          QuestionChangedWorker.perform_async(question.ticket.id, current_user.tn, 'create', request.headers['origin'])

          render json: question, serializer: Questions::QuestionResponsibleUserSerializer
        else
          render json: question.errors, status: :unprocessable_entity
        end
      end

      def update
        question = Service.find(params[:service_id]).questions.find(params[:id])
        authorize question
        decorated_ticket = QuestionDecorator.new(question)

        if decorated_ticket.update_by_state(attributive_params)
          policy_attributes = policy(Question).attributes_for_show
          notify_ticket_id = decorated_ticket.original ? decorated_ticket.original.ticket.id : decorated_ticket.ticket.id
          QuestionChangedWorker.perform_async(notify_ticket_id, current_user.tn, 'update', request.headers['origin'])

          render json: decorated_ticket, serializer: policy_attributes.serializer, include: policy_attributes.serialize
        else
          render json: decorated_ticket.errors, status: :unprocessable_entity
        end
      end

      def destroy
        question = Service.find(params[:service_id]).questions.find(params[:id])
        authorize Ticket
        decorated_ticket = QuestionDecorator.new(question)

        if decorated_ticket.destroy_by_state
          render json: question
        else
          render json: question.errors, status: :unprocessable_entity
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

        questions = QuestionsQuery.new.waiting_for_publish(params[:ids].split(','))
        published = questions.map do |question|
          decorated_ticket = QuestionDecorator.new(question)
          decorated_ticket.publish ? question.reload : nil
        end
        policy_attributes = policy(Question).attributes_for_show

        render json: published, each_serializer: policy_attributes.serializer, include: policy_attributes.serialize
      end

      protected

      def question_params
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
          answers: %i[id _destroy question_id reason answer link is_hidden],
        )
      end

      def attributive_params
        attributive_params = question_params
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
