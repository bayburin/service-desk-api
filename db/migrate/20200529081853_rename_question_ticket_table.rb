class RenameQuestionTicketTable < ActiveRecord::Migration[5.2]
  def change
    rename_table :question_tickets, :questions
    rename_column :answers, :question_ticket_id, :question_id
  end
end
