class CreateEventLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :event_logs do |t|
      t.integer :event_type, index: true
      t.json :body
      t.timestamps
    end
  end
end
