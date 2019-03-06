class CreateTicketTags < ActiveRecord::Migration[5.2]
  def change
    create_table :ticket_tags do |t|
      t.references :ticket
      t.references :tag
      t.timestamps
    end
  end
end
