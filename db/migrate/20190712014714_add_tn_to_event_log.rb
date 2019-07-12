class AddTnToEventLog < ActiveRecord::Migration[5.2]
  def change
    add_column :event_logs, :tn, :integer, index: true, after: :event_type
  end
end
