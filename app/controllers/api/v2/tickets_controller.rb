class Api::V2::TicketsController < Api::V2::BaseController
  def index
    render(
      json: Ticket
              .where(ticketable_type: 'FreeApplication')
              .or(Ticket.where(ticketable_type: nil))
              .includes(:responsible_users, service: :responsible_users),
      each_serializer: Api::V2::TicketOrbitaSerializer
    )
  end

  def show
    render json: Ticket.find(params[:id]), include: ['*']
  end

  def show_by_identity
    render json: Ticket.find_by(identity: params[:identity_id]), include: ['*']
  end
end
