class AddIdentityToTicket < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :identity, :integer, after: :id, index: true
  end
end
