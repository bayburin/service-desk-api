class Api::V2::TicketsController < Api::V2::BaseController
  def show
    render json: Ticket.find(params[:id]), include: ['*']
  end

  def show_by_identity
    render json: Ticket.find_by(identity: params[:identity_id]), include: ['*']
  end
end
