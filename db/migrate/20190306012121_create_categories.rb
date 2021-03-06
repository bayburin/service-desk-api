class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.text :short_description
      t.integer :popularity, index: true, default: 0
      t.string :icon_name
      t.timestamps
    end
  end
end
