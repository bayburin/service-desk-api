class AddTicketQuestionIdToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_reference :answers, :question_ticket, foreign_key: true, after: :id, index: true
  end
end
