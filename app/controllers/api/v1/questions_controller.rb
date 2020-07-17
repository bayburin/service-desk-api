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
        create = Questions::Create.call(params: question_params)

        if create.success?
          QuestionChangedWorker.perform_async(create.question.ticket.id, current_user.tn, 'create', request.headers['origin'])

          render json: create.question, serializer: Questions::QuestionResponsibleUserSerializer
        else
          render json: create.errors, status: :unprocessable_entity
        end
      end

      def update
        question = Service.find(params[:service_id]).questions.find(params[:id])
        authorize question
        decorated_question = QuestionDecorator.new(question)

        if decorated_question.update_by_state(question_params)
          policy_attributes = policy(Question).attributes_for_show
          notify_ticket_id = decorated_question.original ? decorated_question.original.ticket.id : decorated_question.ticket.id
          QuestionChangedWorker.perform_async(notify_ticket_id, current_user.tn, 'update', request.headers['origin'])

          render json: decorated_question, serializer: policy_attributes.serializer, include: policy_attributes.serialize
        else
          render json: decorated_question.errors, status: :unprocessable_entity
        end
      end

      def destroy
        question = Service.find(params[:service_id]).questions.find(params[:id])
        authorize Ticket
        decorated_question = QuestionDecorator.new(question)

        if decorated_question.destroy_by_state
          render json: decorated_question
        else
          render json: decorated_question.errors, status: :unprocessable_entity
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
          decorated_question = QuestionDecorator.new(question)
          decorated_question.publish ? question.reload : nil
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
            tags: %i[id name],
            responsible_users: %i[id responseable_type responseable_id tn _destroy]
          ],
          answers: %i[id _destroy question_id reason answer link is_hidden],
        )
      end

      def check_access
        authorize Service.find(params[:service_id]), :tickets_ctrl_access?
      end
    end
  end
end
