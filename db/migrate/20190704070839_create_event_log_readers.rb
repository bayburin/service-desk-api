class CreateEventLogReaders < ActiveRecord::Migration[5.2]
  def change
    create_table :event_log_readers do |t|
      t.references :user, foreigh_key: true, null: false
      t.integer :tn, null: false
      t.references :event_log, foreigh_key: true, null: false
      t.timestamps
    end
  end
end
