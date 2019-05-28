class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.references :service, foreign_key: true, null: false
      t.string :name, null: false
      t.integer :ticket_type, index: true, null: false
      t.boolean :is_hidden, null: false, default: true
      t.integer :sla, limit: 2
      t.boolean :to_approve, null: false, default: false
      t.integer :popularity, index: true, default: 0
      t.timestamps
    end
  end
end
