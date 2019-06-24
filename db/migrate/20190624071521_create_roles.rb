class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.string :name
      t.string :short_description
      t.text :long_description

      t.timestamps
    end
  end
end
