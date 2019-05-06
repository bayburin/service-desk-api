module Api
  module V1
    class AnswersController < BaseController
      impressionist

      # def index
      #   ticket = Ticket.find(params[:ticket_id])
      #   impressionist ticket

      #   answers = ticket.answers.includes(ticket: { service: :category })

      #   render json: answers, include: 'ticket.service.category'
      # end
    end
  end
end
