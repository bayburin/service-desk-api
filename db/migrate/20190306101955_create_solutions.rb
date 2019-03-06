class CreateSolutions < ActiveRecord::Migration[5.2]
  def change
    create_table :solutions do |t|
      t.references :ticket
      t.text :reason
      t.text :solution
      t.timestamps
    end
  end
end
