class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.references :ticket
      t.text :reason
      t.text :answer
      t.text :link
      t.timestamps
    end
  end
end
