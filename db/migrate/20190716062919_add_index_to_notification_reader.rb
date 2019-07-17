class AddIndexToNotificationReader < ActiveRecord::Migration[5.2]
  def change
    add_index :notification_readers, [:tn, :notification_id]
  end
end
