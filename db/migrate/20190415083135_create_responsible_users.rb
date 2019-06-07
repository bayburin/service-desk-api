class CreateResponsibleUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :responsible_users do |t|
      t.references :responseable, polymorphic: true, index: true
      t.integer :tn, null: false, index: true
      t.timestamps
    end
  end
end
