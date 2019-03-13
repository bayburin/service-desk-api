class AddDeltaIndex < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :delta, :boolean, default: true
    add_column :services, :delta, :boolean, default: true
    add_column :tickets, :delta, :boolean, default: true
  end
end
