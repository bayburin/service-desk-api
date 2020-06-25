class AddNullToAttributes < ActiveRecord::Migration[5.2]
  def change
    change_column_null(:tickets, :ticket_type, true)
    change_column_null(:answers, :ticket_id, true)
  end
end
