class CreateAnswerAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :answer_attachments do |t|
      t.references :answer, foreign_key: true, null: false
      t.string :document
      t.timestamps
    end
  end
end
