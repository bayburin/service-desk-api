class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.references :ticket, foreign_key: true, null: false
      t.text :reason
      t.text :answer, null: false
      t.text :link
      t.boolean :is_hidden, null: false, default: true
      t.timestamps
    end
  end
end
