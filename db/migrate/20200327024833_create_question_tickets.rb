class CreateQuestionTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :question_tickets do |t|
      t.integer :original_id

      t.timestamps
    end

    add_index :question_tickets, :original_id
  end
end
