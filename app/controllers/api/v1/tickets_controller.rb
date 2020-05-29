module Api
  module V1
    class TicketsController < BaseController
      def index
        tickets = TicketsQuery.new.all_in_service(Service.find(params[:service_id])).draft_state

        policy_attributes = policy(QuestionTicket).attributes_for_show
        questions = QuestionTicketsQuery.new(QuestionTicket.where(ticket: tickets))
                      .all
                      .includes(policy_attributes.sql_include)
                      .draft

        render json: {
          questions: ActiveModelSerializers::SerializableResource.new(questions, each_serializer: policy_attributes.serializer, include: policy_attributes.serialize).serializable_hash,
          cases: []
        }
      end
    end
  end
end
