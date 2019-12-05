class AddStateToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :state, :integer, after: :ticket_type, null: false
    add_column :tickets, :original_id, :integer, after: :service_id

    add_index :tickets, :state
    add_index :tickets, :original_id
  end
end
