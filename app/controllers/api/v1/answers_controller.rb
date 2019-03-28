module Api
  module V1
    class AnswersController < BaseController
      impressionist

      def index
        answers = Answer.where(ticket_id: params[:ticket_id]).includes(ticket: { service: :category })

        render json: answers, include: 'ticket.service.category'
      end
    end
  end
end
