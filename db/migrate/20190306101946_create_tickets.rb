class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.references :service
      t.string :name
      t.integer :ticket_type
      t.boolean :is_hidden, null: false, default: true
      t.string :sla
      t.integer :popularity, index: true, default: 0
      t.timestamps
    end
  end
end
