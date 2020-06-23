class AddTicketableToTickets < ActiveRecord::Migration[5.2]
  def change
    add_reference :tickets, :ticketable, after: :ticket_type, polymorphic: true
  end
end
