class RenameEventLogsTables < ActiveRecord::Migration[5.2]
  def change
    rename_table :event_logs, :notifications
    rename_table :event_log_readers, :notification_readers

    remove_reference :notification_readers, :event_log
    add_reference :notification_readers, :notification, foreigh_key: true, null: false, after: :tn
  end
end
