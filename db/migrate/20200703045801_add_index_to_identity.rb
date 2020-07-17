class AddIndexToIdentity < ActiveRecord::Migration[5.2]
  def change
    add_index :tickets, :identity
  end
end
